/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 * Rodar npx eslint --ext .js,.ts . --fix antes de fazer deploy, caso haja erros
 */

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import {
  CieloConstructor,
  Cielo,
  TransactionCreditCardRequestModel,
  EnumBrands,
  CaptureRequestModel,
} from "cielo";

admin.initializeApp(functions.config().firebase);

const merchantid = functions.config().cielo.merchantid;
const merchantkey = functions.config().cielo.merchantkey;

const cieloParams: CieloConstructor = {
  merchantId: merchantid,
  merchantKey: merchantkey,
  sandbox: true,
  debug: true,
};

const cielo = new Cielo(cieloParams);


export const authorizeCreditCard = functions.https
  .onCall(async (data, context) => {
    if (data === null) {
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": "Dados não Informados",
        },
      };
    }

    if (!context.auth) {
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": "Nenhum Usuário Logado",
        },
      };
    }

    const userId = context.auth.uid;

    const snapshot =
      await admin.firestore().collection("users").doc(userId).get();
    const userData = snapshot.data() || {};

    console.log("Iniciando Autorização");

    let brand: EnumBrands;
    switch (data.creditCard.brand) {
    case "VISA":
      brand = EnumBrands.VISA;
      break;
    case "MASTERCARD":
      brand = EnumBrands.MASTER;
      break;
    case "AMEX":
      brand = EnumBrands.AMEX;
      break;
    case "ELO":
      brand = EnumBrands.ELO;
      break;
    case "JCB":
      brand = EnumBrands.JCB;
      break;
    case "DINERSCLUB":
      brand = EnumBrands.DINERS;
      break;
    case "DISCOVER":
      brand = EnumBrands.DISCOVERY;
      break;
    case "HIPERCARD":
      brand = EnumBrands.HIPERCARD;
      break;
    default:
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": "Cartão Não Suportado: " + data.creditCard.brand,
        },
      };
    }

    const saleData: TransactionCreditCardRequestModel = {
      merchantOrderId: data.merchantOrderId,
      customer: {
        name: userData.name,
        identity: data.cpf,
        identityType: "CPF",
        email: userData.email,
        deliveryAddress: {
          street: userData.address.street,
          number: userData.address.number,
          complement: userData.address.complement,
          zipCode: userData.address.zipCode.replace(".", "").replace("-", ""),
          city: userData.address.city,
          state: userData.address.state,
          country: "BRA",
          district: userData.address.district,
        },
      },
      payment: {
        currency: "BRL",
        country: "BRA",
        amount: data.amount,
        installments: data.installments,
        softDescriptor: data.softDescriptor,
        type: data.paymentType,
        capture: false,
        creditCard: {
          cardNumber: data.creditCard.cardNumber,
          holder: data.creditCard.holder,
          expirationDate: data.creditCard.expirationDate,
          securityCode: data.creditCard.securityCode,
          brand: brand,
        },
      },
    };

    try {
      const transaction = await cielo.creditCard.transaction(saleData);

      if (transaction.payment.status === 1) {
        return {
          "success": true,
          "paymentId": transaction.payment.paymentId,
        };
      } else {
        let message = "";
        switch (transaction.payment.returnCode) {
        case "5":
          message = "Não Autorizada";
          break;
        case "57":
          message = "Cartão expirado";
          break;
        case "78":
          message = "Cartão bloqueado";
          break;
        case "99":
          message = "Timeout";
          break;
        case "77":
          message = "Cartão cancelado";
          break;
        case "70":
          message = "Problemas com o Cartão de Crédito";
          break;
        default:
          message = transaction.payment.returnMessage;
          break;
        }
        return {
          "success": false,
          "status": transaction.payment.status,
          "error": {
            "code": transaction.payment.returnCode,
            "message": message,
          },
        };
      }
    } catch (error) {
      console.log("ERROR", error);
      return {
        "success": false,
        "error": {
          "message": error,
        },
      };
    }
  });

export const captureCreditCard =
  functions.https.onCall(async (data, context) => {
    if (data === null) {
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": "Dados não Informados",
        },
      };
    }

    if (!context.auth) {
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": "Nenhum Usuário Logado",
        },
      };
    }

    const captureParams: CaptureRequestModel = {paymentId: data.payId};

    try {
      const capture =
        await cielo.creditCard.captureSaleTransaction(captureParams);
      if (capture.status === 2) {
        return {
          "success": true,
        };
      } else {
        return {
          "success": false,
          "status": capture.status,
          "error": {
            "code": capture.returnCode,
            "message": capture.returnMessage,
          },
        };
      }
    } catch (error) {
      console.log("ERROR", error);
      return {
        "success": false,
        "error": {
          "message": error,
        },
      };
    }
  });
