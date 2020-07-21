import ballerina/log;
import ballerina/http;
import ballerina/time;
import ballerina/runtime;

import wso2/gateway;


    http:Client PizzaShackAPI__1_0_0_prod = new (
gateway:retrieveConfig("api_30e623704c5c5479b7c0d9ab78e965df02c1610401e37cbd557e6353e3191c76_prod_endpoint_0","https://localhost:9443/am/sample/pizzashack/v1/api/"),
{ 
   httpVersion: gateway:getHttpVersion(),
    cache: { enabled: false }

,
secureSocket:{
    trustStore: {
           path: gateway:getConfigValue(gateway:LISTENER_CONF_INSTANCE_ID, gateway:TRUST_STORE_PATH,
               gateway:DEFAULT_TRUST_STORE_PATH),
           password: gateway:getConfigValue(gateway:LISTENER_CONF_INSTANCE_ID, gateway:TRUST_STORE_PASSWORD, gateway:DEFAULT_TRUST_STORE_PASSWORD)
     },
     verifyHostname:gateway:getConfigBooleanValue(gateway:HTTP_CLIENTS_INSTANCE_ID, gateway:ENABLE_HOSTNAME_VERIFICATION, true)
}

});


    http:Client PizzaShackAPI__1_0_0_sand = new (
gateway:retrieveConfig("api_30e623704c5c5479b7c0d9ab78e965df02c1610401e37cbd557e6353e3191c76_sand_endpoint_0","https://localhost:9443/am/sample/pizzashack/v1/api/"),
{ 
   httpVersion: gateway:getHttpVersion(),
    cache: { enabled: false }

,
secureSocket:{
    trustStore: {
           path: gateway:getConfigValue(gateway:LISTENER_CONF_INSTANCE_ID, gateway:TRUST_STORE_PATH,
               gateway:DEFAULT_TRUST_STORE_PATH),
           password: gateway:getConfigValue(gateway:LISTENER_CONF_INSTANCE_ID, gateway:TRUST_STORE_PASSWORD, gateway:DEFAULT_TRUST_STORE_PASSWORD)
     },
     verifyHostname:gateway:getConfigBooleanValue(gateway:HTTP_CLIENTS_INSTANCE_ID, gateway:ENABLE_HOSTNAME_VERIFICATION, true)
}

});







    
    
    
    
    
    

    
    

    
    


    
    
    
    
    
    

    
    

    
    


    
    
    
    
    
    

    
    

    
    


    
    
    
    
    
    

    
    

    
    


    
    
    
    
    
    

    
    

    
    











@http:ServiceConfig {
    basePath: "/pizzashack/1.0.0",
    auth: {
        authHandlers: gateway:getAuthHandlers(["oauth2","jwt"], false, false)
    }
   ,
    cors: {
         allowOrigins: ["*"],
         allowCredentials: false,
         allowHeaders: ["authorization","Access-Control-Allow-Origin","Content-Type","SOAPAction","apikey"],
         allowMethods: ["GET","PUT","POST","DELETE","PATCH","OPTIONS"]
    }
    
}

@gateway:API {
    publisher:"",
    name:"PizzaShackAPI",
    apiVersion: "1.0.0",
    apiTier : "" ,
    authorizationHeader : "Authorization" ,
    authProviders: ["oauth2","jwt"],
    security: {
            "apikey":[],
            "mutualSSL": "",
            "applicationSecurityOptional": false
        }
}
service PizzaShackAPI__1_0_0 on apiListener,
apiSecureListener {


    @http:ResourceConfig {
        methods:["POST"],
        path:"/order",
        auth:{
        
            
        
            authHandlers: gateway:getAuthHandlers(["oauth2","jwt"], false, false)
        }
    }
    @gateway:Resource {
        authProviders: ["oauth2","jwt"],
        security: {
            "apikey":[],
            "applicationSecurityOptional": false 
            }
    }
    @gateway:RateLimit{policy : "Unlimited"}
    resource function post0b7cd6d98c434379b8ba7c5c60ed6a8a (http:Caller outboundEp, http:Request req) {
        handleExpectHeaderForPizzaShackAPI__1_0_0(outboundEp, req);
        runtime:InvocationContext invocationContext = runtime:getInvocationContext();
        

        
        string urlPostfix = gateway:replaceFirst(req.rawPath,"/pizzashack/1.0.0","");
        
        if(urlPostfix != "" && !gateway:hasPrefix(urlPostfix, "/")) {
            urlPostfix = "/" + urlPostfix;
        }
        http:Response|error clientResponse;
        http:Response r = new;
        clientResponse = r;
        string destination_attribute;
        invocationContext.attributes["timeStampRequestOut"] = time:currentTime().time;
        boolean reinitRequired = false;
        string failedEtcdKey = "";
        string failedEtcdKeyConfigValue = "";
        boolean|error hasUrlChanged;
        http:ClientConfiguration newConfig;
        boolean reinitFailed = false;
        boolean isProdEtcdEnabled = false;
        boolean isSandEtcdEnabled = false;
        map<string> endpointEtcdConfigValues = {};
        
            
                if("PRODUCTION" == <string>invocationContext.attributes["KEY_TYPE"]) {
                
                    
    clientResponse = PizzaShackAPI__1_0_0_prod->forward(urlPostfix, <@untainted>req);

invocationContext.attributes["destination"] = "https://localhost:9443/am/sample/pizzashack/v1/api/";
                
                } else {
                
                    
    clientResponse = PizzaShackAPI__1_0_0_sand->forward(urlPostfix, <@untainted>req);

invocationContext.attributes["destination"] = "https://localhost:9443/am/sample/pizzashack/v1/api/";
                
                }
            
            
        
        
        invocationContext.attributes["timeStampResponseIn"] = time:currentTime().time;


        if(clientResponse is http:Response) {
            
            var outboundResult = outboundEp->respond(clientResponse);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        } else {
            http:Response res = new;
            res.statusCode = 500;
            string errorMessage = clientResponse.reason();
            int errorCode = 101503;
            string errorDescription = "Error connecting to the back end";

            if(gateway:contains(errorMessage, "connection timed out") || gateway:contains(errorMessage,"Idle timeout triggered")) {
                errorCode = 101504;
                errorDescription = "Connection timed out";
            }
            if(gateway:contains(errorMessage, "Malformed URL")) {
                errorCode = 101505;
                errorDescription = "Malformed URL";
            }
            invocationContext.attributes["error_response_code"] = errorCode;
            invocationContext.attributes["error_response"] = errorDescription;
            if (! invocationContext.attributes.hasKey(gateway:IS_GRPC)) {
                json payload = {fault : {
                                code : errorCode,
                                message : "Runtime Error",
                                description : errorDescription
                            }};

                            res.setPayload(payload);
            } else {
                gateway:attachGrpcErrorHeaders (res, errorDescription);
            }
            log:printError("Error in client response", err = clientResponse);
            var outboundResult = outboundEp->respond(res);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        }
    }


    @http:ResourceConfig {
        methods:["GET"],
        path:"/menu",
        auth:{
        
            
        
            authHandlers: gateway:getAuthHandlers(["oauth2","jwt"], false, false)
        }
    }
    @gateway:Resource {
        authProviders: ["oauth2","jwt"],
        security: {
            "apikey":[],
            "applicationSecurityOptional": false 
            }
    }
    @gateway:RateLimit{policy : "Unlimited"}
    resource function get675b234316a54297925d48f8e3ebda03 (http:Caller outboundEp, http:Request req) {
        handleExpectHeaderForPizzaShackAPI__1_0_0(outboundEp, req);
        runtime:InvocationContext invocationContext = runtime:getInvocationContext();
        

        
        string urlPostfix = gateway:replaceFirst(req.rawPath,"/pizzashack/1.0.0","");
        
        if(urlPostfix != "" && !gateway:hasPrefix(urlPostfix, "/")) {
            urlPostfix = "/" + urlPostfix;
        }
        http:Response|error clientResponse;
        http:Response r = new;
        clientResponse = r;
        string destination_attribute;
        invocationContext.attributes["timeStampRequestOut"] = time:currentTime().time;
        boolean reinitRequired = false;
        string failedEtcdKey = "";
        string failedEtcdKeyConfigValue = "";
        boolean|error hasUrlChanged;
        http:ClientConfiguration newConfig;
        boolean reinitFailed = false;
        boolean isProdEtcdEnabled = false;
        boolean isSandEtcdEnabled = false;
        map<string> endpointEtcdConfigValues = {};
        
            
                if("PRODUCTION" == <string>invocationContext.attributes["KEY_TYPE"]) {
                
                    
    clientResponse = PizzaShackAPI__1_0_0_prod->forward(urlPostfix, <@untainted>req);

invocationContext.attributes["destination"] = "https://localhost:9443/am/sample/pizzashack/v1/api/";
                
                } else {
                
                    
    clientResponse = PizzaShackAPI__1_0_0_sand->forward(urlPostfix, <@untainted>req);

invocationContext.attributes["destination"] = "https://localhost:9443/am/sample/pizzashack/v1/api/";
                
                }
            
            
        
        
        invocationContext.attributes["timeStampResponseIn"] = time:currentTime().time;


        if(clientResponse is http:Response) {
            
            var outboundResult = outboundEp->respond(clientResponse);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        } else {
            http:Response res = new;
            res.statusCode = 500;
            string errorMessage = clientResponse.reason();
            int errorCode = 101503;
            string errorDescription = "Error connecting to the back end";

            if(gateway:contains(errorMessage, "connection timed out") || gateway:contains(errorMessage,"Idle timeout triggered")) {
                errorCode = 101504;
                errorDescription = "Connection timed out";
            }
            if(gateway:contains(errorMessage, "Malformed URL")) {
                errorCode = 101505;
                errorDescription = "Malformed URL";
            }
            invocationContext.attributes["error_response_code"] = errorCode;
            invocationContext.attributes["error_response"] = errorDescription;
            if (! invocationContext.attributes.hasKey(gateway:IS_GRPC)) {
                json payload = {fault : {
                                code : errorCode,
                                message : "Runtime Error",
                                description : errorDescription
                            }};

                            res.setPayload(payload);
            } else {
                gateway:attachGrpcErrorHeaders (res, errorDescription);
            }
            log:printError("Error in client response", err = clientResponse);
            var outboundResult = outboundEp->respond(res);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        }
    }


    @http:ResourceConfig {
        methods:["GET"],
        path:"/order/{orderId}",
        auth:{
        
            
        
            authHandlers: gateway:getAuthHandlers(["oauth2","jwt"], false, false)
        }
    }
    @gateway:Resource {
        authProviders: ["oauth2","jwt"],
        security: {
            "apikey":[],
            "applicationSecurityOptional": false 
            }
    }
    @gateway:RateLimit{policy : "Unlimited"}
    resource function getb20bb87c797949918aa776aacdbc9090 (http:Caller outboundEp, http:Request req) {
        handleExpectHeaderForPizzaShackAPI__1_0_0(outboundEp, req);
        runtime:InvocationContext invocationContext = runtime:getInvocationContext();
        

        
        string urlPostfix = gateway:replaceFirst(req.rawPath,"/pizzashack/1.0.0","");
        
        if(urlPostfix != "" && !gateway:hasPrefix(urlPostfix, "/")) {
            urlPostfix = "/" + urlPostfix;
        }
        http:Response|error clientResponse;
        http:Response r = new;
        clientResponse = r;
        string destination_attribute;
        invocationContext.attributes["timeStampRequestOut"] = time:currentTime().time;
        boolean reinitRequired = false;
        string failedEtcdKey = "";
        string failedEtcdKeyConfigValue = "";
        boolean|error hasUrlChanged;
        http:ClientConfiguration newConfig;
        boolean reinitFailed = false;
        boolean isProdEtcdEnabled = false;
        boolean isSandEtcdEnabled = false;
        map<string> endpointEtcdConfigValues = {};
        
            
                if("PRODUCTION" == <string>invocationContext.attributes["KEY_TYPE"]) {
                
                    
    clientResponse = PizzaShackAPI__1_0_0_prod->forward(urlPostfix, <@untainted>req);

invocationContext.attributes["destination"] = "https://localhost:9443/am/sample/pizzashack/v1/api/";
                
                } else {
                
                    
    clientResponse = PizzaShackAPI__1_0_0_sand->forward(urlPostfix, <@untainted>req);

invocationContext.attributes["destination"] = "https://localhost:9443/am/sample/pizzashack/v1/api/";
                
                }
            
            
        
        
        invocationContext.attributes["timeStampResponseIn"] = time:currentTime().time;


        if(clientResponse is http:Response) {
            
            var outboundResult = outboundEp->respond(clientResponse);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        } else {
            http:Response res = new;
            res.statusCode = 500;
            string errorMessage = clientResponse.reason();
            int errorCode = 101503;
            string errorDescription = "Error connecting to the back end";

            if(gateway:contains(errorMessage, "connection timed out") || gateway:contains(errorMessage,"Idle timeout triggered")) {
                errorCode = 101504;
                errorDescription = "Connection timed out";
            }
            if(gateway:contains(errorMessage, "Malformed URL")) {
                errorCode = 101505;
                errorDescription = "Malformed URL";
            }
            invocationContext.attributes["error_response_code"] = errorCode;
            invocationContext.attributes["error_response"] = errorDescription;
            if (! invocationContext.attributes.hasKey(gateway:IS_GRPC)) {
                json payload = {fault : {
                                code : errorCode,
                                message : "Runtime Error",
                                description : errorDescription
                            }};

                            res.setPayload(payload);
            } else {
                gateway:attachGrpcErrorHeaders (res, errorDescription);
            }
            log:printError("Error in client response", err = clientResponse);
            var outboundResult = outboundEp->respond(res);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        }
    }


    @http:ResourceConfig {
        methods:["PUT"],
        path:"/order/{orderId}",
        auth:{
        
            
        
            authHandlers: gateway:getAuthHandlers(["oauth2","jwt"], false, false)
        }
    }
    @gateway:Resource {
        authProviders: ["oauth2","jwt"],
        security: {
            "apikey":[],
            "applicationSecurityOptional": false 
            }
    }
    @gateway:RateLimit{policy : "Unlimited"}
    resource function put0c87694321594377ab5bef0a94bd92b3 (http:Caller outboundEp, http:Request req) {
        handleExpectHeaderForPizzaShackAPI__1_0_0(outboundEp, req);
        runtime:InvocationContext invocationContext = runtime:getInvocationContext();
        

        
        string urlPostfix = gateway:replaceFirst(req.rawPath,"/pizzashack/1.0.0","");
        
        if(urlPostfix != "" && !gateway:hasPrefix(urlPostfix, "/")) {
            urlPostfix = "/" + urlPostfix;
        }
        http:Response|error clientResponse;
        http:Response r = new;
        clientResponse = r;
        string destination_attribute;
        invocationContext.attributes["timeStampRequestOut"] = time:currentTime().time;
        boolean reinitRequired = false;
        string failedEtcdKey = "";
        string failedEtcdKeyConfigValue = "";
        boolean|error hasUrlChanged;
        http:ClientConfiguration newConfig;
        boolean reinitFailed = false;
        boolean isProdEtcdEnabled = false;
        boolean isSandEtcdEnabled = false;
        map<string> endpointEtcdConfigValues = {};
        
            
                if("PRODUCTION" == <string>invocationContext.attributes["KEY_TYPE"]) {
                
                    
    clientResponse = PizzaShackAPI__1_0_0_prod->forward(urlPostfix, <@untainted>req);

invocationContext.attributes["destination"] = "https://localhost:9443/am/sample/pizzashack/v1/api/";
                
                } else {
                
                    
    clientResponse = PizzaShackAPI__1_0_0_sand->forward(urlPostfix, <@untainted>req);

invocationContext.attributes["destination"] = "https://localhost:9443/am/sample/pizzashack/v1/api/";
                
                }
            
            
        
        
        invocationContext.attributes["timeStampResponseIn"] = time:currentTime().time;


        if(clientResponse is http:Response) {
            
            var outboundResult = outboundEp->respond(clientResponse);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        } else {
            http:Response res = new;
            res.statusCode = 500;
            string errorMessage = clientResponse.reason();
            int errorCode = 101503;
            string errorDescription = "Error connecting to the back end";

            if(gateway:contains(errorMessage, "connection timed out") || gateway:contains(errorMessage,"Idle timeout triggered")) {
                errorCode = 101504;
                errorDescription = "Connection timed out";
            }
            if(gateway:contains(errorMessage, "Malformed URL")) {
                errorCode = 101505;
                errorDescription = "Malformed URL";
            }
            invocationContext.attributes["error_response_code"] = errorCode;
            invocationContext.attributes["error_response"] = errorDescription;
            if (! invocationContext.attributes.hasKey(gateway:IS_GRPC)) {
                json payload = {fault : {
                                code : errorCode,
                                message : "Runtime Error",
                                description : errorDescription
                            }};

                            res.setPayload(payload);
            } else {
                gateway:attachGrpcErrorHeaders (res, errorDescription);
            }
            log:printError("Error in client response", err = clientResponse);
            var outboundResult = outboundEp->respond(res);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        }
    }


    @http:ResourceConfig {
        methods:["DELETE"],
        path:"/order/{orderId}",
        auth:{
        
            
        
            authHandlers: gateway:getAuthHandlers(["oauth2","jwt"], false, false)
        }
    }
    @gateway:Resource {
        authProviders: ["oauth2","jwt"],
        security: {
            "apikey":[],
            "applicationSecurityOptional": false 
            }
    }
    @gateway:RateLimit{policy : "Unlimited"}
    resource function delete96fc0e80a5ff4ba89fdc40fd9ced51d3 (http:Caller outboundEp, http:Request req) {
        handleExpectHeaderForPizzaShackAPI__1_0_0(outboundEp, req);
        runtime:InvocationContext invocationContext = runtime:getInvocationContext();
        

        
        string urlPostfix = gateway:replaceFirst(req.rawPath,"/pizzashack/1.0.0","");
        
        if(urlPostfix != "" && !gateway:hasPrefix(urlPostfix, "/")) {
            urlPostfix = "/" + urlPostfix;
        }
        http:Response|error clientResponse;
        http:Response r = new;
        clientResponse = r;
        string destination_attribute;
        invocationContext.attributes["timeStampRequestOut"] = time:currentTime().time;
        boolean reinitRequired = false;
        string failedEtcdKey = "";
        string failedEtcdKeyConfigValue = "";
        boolean|error hasUrlChanged;
        http:ClientConfiguration newConfig;
        boolean reinitFailed = false;
        boolean isProdEtcdEnabled = false;
        boolean isSandEtcdEnabled = false;
        map<string> endpointEtcdConfigValues = {};
        
            
                if("PRODUCTION" == <string>invocationContext.attributes["KEY_TYPE"]) {
                
                    
    clientResponse = PizzaShackAPI__1_0_0_prod->forward(urlPostfix, <@untainted>req);

invocationContext.attributes["destination"] = "https://localhost:9443/am/sample/pizzashack/v1/api/";
                
                } else {
                
                    
    clientResponse = PizzaShackAPI__1_0_0_sand->forward(urlPostfix, <@untainted>req);

invocationContext.attributes["destination"] = "https://localhost:9443/am/sample/pizzashack/v1/api/";
                
                }
            
            
        
        
        invocationContext.attributes["timeStampResponseIn"] = time:currentTime().time;


        if(clientResponse is http:Response) {
            
            var outboundResult = outboundEp->respond(clientResponse);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        } else {
            http:Response res = new;
            res.statusCode = 500;
            string errorMessage = clientResponse.reason();
            int errorCode = 101503;
            string errorDescription = "Error connecting to the back end";

            if(gateway:contains(errorMessage, "connection timed out") || gateway:contains(errorMessage,"Idle timeout triggered")) {
                errorCode = 101504;
                errorDescription = "Connection timed out";
            }
            if(gateway:contains(errorMessage, "Malformed URL")) {
                errorCode = 101505;
                errorDescription = "Malformed URL";
            }
            invocationContext.attributes["error_response_code"] = errorCode;
            invocationContext.attributes["error_response"] = errorDescription;
            if (! invocationContext.attributes.hasKey(gateway:IS_GRPC)) {
                json payload = {fault : {
                                code : errorCode,
                                message : "Runtime Error",
                                description : errorDescription
                            }};

                            res.setPayload(payload);
            } else {
                gateway:attachGrpcErrorHeaders (res, errorDescription);
            }
            log:printError("Error in client response", err = clientResponse);
            var outboundResult = outboundEp->respond(res);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        }
    }

}

    function handleExpectHeaderForPizzaShackAPI__1_0_0 (http:Caller outboundEp, http:Request req ) {
        if (req.expects100Continue()) {
            req.removeHeader("Expect");
            var result = outboundEp->continue();
            if (result is error) {
            log:printError("Error while sending 100 continue response", err = result);
            }
        }
    }

function getUrlOfEtcdKeyForReInitPizzaShackAPI__1_0_0(string defaultUrlRef,string etcdRef, string defaultUrl, string etcdKey) returns string {
    string retrievedEtcdKey = <string> gateway:retrieveConfig(etcdRef,etcdKey);
    map<any> urlChangedMap = gateway:getUrlChangedMap();
    urlChangedMap[<string> retrievedEtcdKey] = false;
    map<string> etcdUrls = gateway:getEtcdUrlsMap();
    string url = <string> etcdUrls[retrievedEtcdKey];
    if (url == "") {
        return <string> gateway:retrieveConfig(defaultUrlRef, defaultUrl);
    } else {
        return url;
    }
}

function respondFromJavaInterceptorPizzaShackAPI__1_0_0(runtime:InvocationContext invocationContext, http:Caller outboundEp) returns boolean {
    boolean tryRespond = false;
    if(invocationContext.attributes.hasKey(gateway:RESPOND_DONE) && invocationContext.attributes.hasKey(gateway:RESPONSE_OBJECT)) {
        if(<boolean>invocationContext.attributes[gateway:RESPOND_DONE]) {
            http:Response clientResponse = <http:Response>invocationContext.attributes[gateway:RESPONSE_OBJECT];
            var outboundResult = outboundEp->respond(clientResponse);
            if (outboundResult is error) {
                log:printError("Error when sending response from the interceptor", err = outboundResult);
            }
            tryRespond = true;
        }
    }
    return tryRespond;
}

function initInterceptorIndexesPizzaShackAPI__1_0_0() {


    
        

        
        


    
        

        
        


    
        

        
        


    
        

        
        


    
        

        
        


}