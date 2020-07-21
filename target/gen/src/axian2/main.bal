import wso2/gateway;

public function main() {
    int totalResourceLength = 0;
    boolean isRequestValidationEnabled  = gateway:getConfigBooleanValue(gateway:VALIDATION_CONFIG_INSTANCE_ID,
    gateway:REQUEST_VALIDATION_ENABLED, gateway:DEFAULT_REQUEST_VALIDATION_ENABLED);
    boolean isResponseValidationEnabled  = gateway:getConfigBooleanValue(gateway:VALIDATION_CONFIG_INSTANCE_ID,
    gateway:RESPONSE_VALIDATION_ENABLED, gateway:DEFAULT_RESPONSE_VALIDATION_ENABLED);
    
    if (isRequestValidationEnabled || isResponseValidationEnabled) {
    error? err = gateway:extractJAR("axian2", "PizzaShackAPI__1_0_0");
    if (err is error) {
        gateway:printError(gateway:MAIN, "Error when retrieving the resources artifacts", err);
    }
    }
    string[] PizzaShackAPI__1_0_0_service = [ "post0b7cd6d98c434379b8ba7c5c60ed6a8a"
                                , "get675b234316a54297925d48f8e3ebda03"
                                , "getb20bb87c797949918aa776aacdbc9090",
                                 "put0c87694321594377ab5bef0a94bd92b3",
                                 "delete96fc0e80a5ff4ba89fdc40fd9ced51d3"
                                ];
    totalResourceLength = totalResourceLength +  PizzaShackAPI__1_0_0_service.length();
    gateway:populateAnnotationMaps("PizzaShackAPI__1_0_0", PizzaShackAPI__1_0_0, PizzaShackAPI__1_0_0_service);
    
    gateway:initiateInterceptorArray(totalResourceLength);
    
    initInterceptorIndexesPizzaShackAPI__1_0_0();
    
    addTokenServicesFilterAnnotation();
    initThrottlePolicies();
    gateway:initThrottleDataPublisher();
    gateway:startObservabilityListener();

    map<string> receivedRevokedTokenMap = gateway:getRevokedTokenMap();
    boolean jmsListenerStarted = gateway:initiateTokenRevocationJmsListener();

    boolean useDefault = gateway:getConfigBooleanValue(gateway:PERSISTENT_MESSAGE_INSTANCE_ID,
        gateway:PERSISTENT_USE_DEFAULT, gateway:DEFAULT_PERSISTENT_USE_DEFAULT);

    //TODO: Re enable this code once the compile errors are fixed
    if (useDefault){
        future<()> initETCDRetriveal = start gateway:etcdRevokedTokenRetrieverTask();
    } else {
        initiatePersistentRevokedTokenRetrieval(receivedRevokedTokenMap);
    }

    startupExtension();

    future<()> callhome = start gateway:invokeCallHome();
}
