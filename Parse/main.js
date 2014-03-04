// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var paymill = require("cloud/paymill.parse.js");
paymill.initialize("PAYMILL_PRIVATE_KEY");



Parse.Cloud.define("getCurrentUserID", function(request, response) {
    Parse.Cloud.useMasterKey();
    var paymillClientId = Parse.User.current().get("paymillClientId");
	response.success(paymillClientId);
});
 //***************
// name: createPaymentByExistingClient
// params:
// clientId
// creditCardNumber
// verification
// amount
// token
//***************
Parse.Cloud.define("createTransactionWithPayment", function(request, response) {
    Parse.Cloud.useMasterKey();
	paymill.transactions.createWithPayment(request.params.paymillPaymentId, request.params.amount, request.params.currency, request.params.description).then(function(transaction) {
		 response.success("success");
	}, function(e) {
		response.error(e);
	});
})

//***************
// name: createPaymentByNewClient
// params:
// clientDescription
// clientEmail
// creditCardNumber
// verification
// amount
// token
//***************
 Parse.Cloud.define("createTransactionWithToken", function(request, response) {
    Parse.Cloud.useMasterKey();
    var paymillClientId = Parse.User.current().get("paymillClientId");
    paymill.payments.create(request.params.token, paymillClientId).then(function(payment) {
		paymill.transactions.createWithPayment(payment.id, request.params.amount, request.params.currency, request.params.description, paymillClientId).then(function(transaction) {
			// we need to verify if the transaction was sucessfull
			// more information here: https://www.paymill.com/en-gb/documentation-3/reference/api-reference/#document-statuscodes
			if (transaction.response_code==20000) {
				response.success("success");
			} else {
				response.error("Transaction (" + transaction.id +") failed with code:"+transaction.response_code);
			}
		});
	}, function(error) {
		response.error(e);
	});
});

//***************
// name: getPayments
// 
//	Get current user's  payments, 
//
//***************
Parse.Cloud.define("getPayments", function(request, response) {
	Parse.Cloud.useMasterKey();
	var clientId = Parse.User.current().get("paymillClientId");
	paymill.clients.detail(clientId).then(function(client) {
		response.success(client.payment);
	}, function(error) {
		response.error("couldnt list payments:" + error);
	});
});

Parse.Cloud.beforeSave("_User", function(request, response) {
	paymill.clients.create(request.object.email, request.object.username).then(function(result) {
		 request.object.set("paymillClientId", result.id);
		 response.success();
	}, function(e) {
		response.error("save user failed" + e);
	});
});

