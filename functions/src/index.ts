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

import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, CaptureRequestModel, CancelTransactionRequestModel, EnumBrands } from "cielo";

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


export const authorizeCreditCard = functions.https.onCall(async (data, context) => {

  if (data === null) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Dados não Informados"
      }
    }
  }

  if (!context.auth) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Nenhum Usuário Logado"
      }
    }
  }

  const userId = context.auth.uid;

  const snapshot = await admin.firestore().collection("users").doc(userId).get();
  const userData = snapshot.data;

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
          "message": "Cartão Não Suportado: " + data.creditCard.brand
        }
      }
  }
});

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = functions.https.onCall((data, context) => {
//     return { data: "Hello from Cloud Functions" };
// });

// FUNÇÃO DE LEITURA

export const getUserData = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    return {
      "data": "Nenhum Usuário Logado",
    };
  }


  const snapshot = await admin.firestore()
    .collection("users").doc(context.auth.uid).get();
  return {
    "data": snapshot.data(),
  };
});

// FUNÇÃO DE ESCRITA

export const addMessage = functions.https.onCall(async (data, context) => {
  const snapshot = await admin.firestore().collection("messages").add(data);

  return { "success": snapshot.id };
});

// FUNÇÃO COM TRIGGER

export const onNewOrder = functions.firestore.document("/orders/{orderId}")
  .onCreate((snapshot, context) => {
    const orderId = context.params.orderId;
    console.log(orderId);
  });
