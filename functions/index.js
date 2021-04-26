const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// const admin = require('firebase-admin');
// admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

exports.observeComments = functions.database.ref('/post-comments/{postID}/{commentId}/').onCreate((snapshot, context) => {
	var postID = context.params.postID;
	var commentId = context.params.commentId;

	return admin.database().ref('/post-comments/' + postID + '/' + commentId).once('value', snapshot => {
		var comment = snapshot.val();
		var commentUid = comment.uid;

		console.log('LOGGER --- commentUid is ' + commentUid);

		return admin.database().ref('/users/' + commentUid).once('value', snapshot => {
			var commentingUser = snapshot.val();
			var fullname = commentingUser.fullname;

			console.log('LOGGER --- fullname is ' + fullname);

		return admin.database().ref('/posts/' + postID).once('value', snapshot => {
			var post = snapshot.val();
			var postOwnerUid = post.uid;

			console.log('LOGGER --- postOwnerUid is ' + postOwnerUid);

			return admin.database().ref('/users/' + postOwnerUid).once('value', snapshot => {
				var postOwner = snapshot.val();

				var payload = {
					notification: {
						body: fullname + ' commented on your post!'
					}
				};

				admin.messaging().sendToDevice(postOwner.fcmToken, payload)
					.then(function(response) {
						console.log('Successfully sent message:', response);
					})
					.catch(function(error) {
						console.log('Error sending message:', error);
					});

				})
			})
		})
	})
})


exports.observeLikes = functions.database.ref('/user-likes/{uid}/{postID}').onCreate((snapshot, context) => {

  var uid = context.params.uid;
	var postID = context.params.postID;

	console.log('LOGGER --- uid is ' + uid);
	console.log('LOGGER --- postID is ' + postID);

	return admin.database().ref('/users/' + uid).once('value', snapshot => {

		var userThatLikePost = snapshot.val();

		return admin.database().ref('/posts/' + postID).once('value', snapshot => {

			var post = snapshot.val();

			return admin.database().ref('/users/' + post.uid).once('value', snapshot => {

				var postOwner = snapshot.val();


				var payload = {
					notification: {
						body: userThatLikePost.fullname + ' liked your post!'
					}
				};

				admin.messaging().sendToDevice(postOwner.fcmToken, payload)
					.then(function(response) {
						console.log('Successfully sent message:', response);
					})
					.catch(function(error) {
						console.log('Error sending message:', error);
					});
			})
		})

	})
})

exports.observeFollow = functions.database.ref('/user-following/{uid}/{followedUid}').onCreate((snapshot, context) => {


	var uid = context.params.uid;
	var followedUid = context.params.followedUid;

	return admin.database().ref('/users/' + followedUid).once('value', snapshot => {
		var userThatWasFollowed = snapshot.val();

		return admin.database().ref('/users/' + uid).once('value', snapshot => {
			var userThatFollowed = snapshot.val();

			var payload = {
				notification: {
					title: 'You have a new follower!',
					body: userThatFollowed.fullname + ' started following you'
				}
			};

			admin.messaging().sendToDevice(userThatWasFollowed.fcmToken, payload)
				.then(function(response) {
					console.log('Successfully sent message:', response);
				})
				.catch(function(error) {
					console.log('Error sending message:', error);
				});

		})
	})
})

exports.observeApplications = functions.database.ref('/user-applications/{uid}/{GigId}').onCreate((snapshot, context) => {

  var uid = context.params.uid;
	var gigID = context.params.GigId;

	console.log('LOGGER --- uid is ' + uid);
	console.log('LOGGER --- gigID is ' + gigID);

	return admin.database().ref('/users/' + uid).once('value', snapshot => {

		var userThatApplied = snapshot.val();

		return admin.database().ref('/gigs/' + gigID).once('value', snapshot => {

			var gig = snapshot.val();

			return admin.database().ref('/users/' + gig.uid).once('value', snapshot => {

				var gigOwner = snapshot.val();


				var payload = {
					notification: {
						body: userThatApplied.fullname + ' applied to your gig posting: ' + gig.title
					}
				};

				admin.messaging().sendToDevice(gigOwner.fcmToken, payload)
					.then(function(response) {
						console.log('Successfully sent message:', response);
					})
					.catch(function(error) {
						console.log('Error sending message:', error);
					});
			})
		})

	})
})


exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});

exports.sendPushNotifications = functions.https.onRequest((req, res) => {

res.send("Attempting to send push notifications")
console.log("LOGGER --- Trying to send push message..");

var uid = 'qDpLmYqIqXPAHdInkwRjvL1uDk23'

return admin.database().ref('/users/' + uid).once('value', snapshot => {


	var user = snapshot.val();

	var fcmToken = 'eGKM8-7WNkz6soHw-jcOOZ:APA91bEwj37dAAPfAIS2Tq-4iLIt7xxVxcuH3n_pST5GLIzWLfild1fxnvRqnmU9BDDa-yZ6S48lS33iIu8OHPUEyIwjwa8WdK5i8n_-fpXQ30QzTgie4BpB-OjDv-sXVx-2Ey40avrW'

	console.log("Username is " + user.username);

	var payload = {
		notification: {
			title: 'Push Notification Title',
			body: 'Test notification message'
		}
	}

	admin.messaging().sendToDevice(fcmToken, payload)
		.then(function(response) {
			console.log('Successfully sent message:', response);
		})
		.catch(function(error) {
			console.log('Error sending message:', error);
		});
})


})
