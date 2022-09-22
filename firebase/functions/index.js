const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.sendCallNotification = functions.https.onCall(async (data,res)=>{
    const roomId= data.roomId;
    const callerName= data.callerName;
    const callerNumber= data.callerNumber;
    const uuid = data.uuid;
    const hasVideo = data.hasVideo;
    const fcm= data.fcm;

    const payLoad= {
        data: {
            roomId: roomId,
            callerName: callerName,
            callerNumber: callerNumber,
            uuid: uuid,
            hasVideo:hasVideo,
        }
    };

    try{
    var response= await admin.messaging().sendToDevice(fcm,payLoad);
    return console.log('Successfully sent',response);
    }catch(error){
        return console.log('Failed',error); 
    }
})
