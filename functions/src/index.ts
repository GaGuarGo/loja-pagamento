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

admin.initializeApp(functions.config().firebase);

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = functions.https.onCall((data, context) => {
//     return { data: "Hello from Cloud Functions" };
// });

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
