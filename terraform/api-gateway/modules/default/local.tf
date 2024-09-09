locals {

    proxy = {
        method = {
            authorization = "CUSTOM"
            authorizer_id = var.api_data.custom_authorizer
            request_method_api_key_required = false
            request_parameters = {
                "method.request.path.proxy" = true
                "method.request.header.token" = true
            }
        }
        integration = {
            uri = "${var.load_balancer}/{proxy}"
            type = "HTTP"
            request_parameters = {
                "integration.request.header.user-id" = "context.authorizer.userId"
                "integration.request.header.token" = "''"
                "integration.request.header.Accept-Encoding" = "identity"
                "integration.request.header.x-http-method-override" = "integration.request.header.method"
                "integration.request.header.auths" = "context.authorizer.auths"
                "integration.request.header.clienttenantid" = "context.authorizer.clienttenantid"
                "integration.request.header.issupplier" = "context.authorizer.isSupplier"
                "integration.request.header.target" = "'${var.path}'"
                "integration.request.header.tenantid" = "context.authorizer.tenantId"
                "integration.request.header.tenantname" = "context.authorizer.tenantName"
                "integration.request.header.useremail" = "context.authorizer.userEmail"
                "integration.request.header.username" = "context.authorizer.userName"
                "integration.request.header.authBranches" = "context.authorizer.authBranches"
                "integration.request.path.proxy" = "method.request.path.proxy"
            }
            request_templates = {
                "application/json" = <<EOF
#set($allParams = $input.params()) 
#set($inputRoot = $input.path('$')) 
{ 
"body-json" : $input.json('$'), 
"api-gateway-params" : { 
"context" : { 
     "authorizations": $context.authorizer.authorizations 
    }, 
#foreach($type in $allParams.keySet()) 
    #set($params = $allParams.get($type)) 
"$type" : { 
    #foreach($paramName in $params.keySet()) 
    "$paramName" : "$util.escapeJavaScript($params.get($paramName))" 
        #if($foreach.hasNext),#end 
    #end 
} 
    #if($foreach.hasNext),#end 
#end 
}
}
                EOF
            }
        }
        integration_response = {
            response_templates = {}
            response_parameters = {
                "method.response.header.Access-Control-Allow-Origin"  = "'*'",
                "method.response.header.content-type"                 = "integration.response.header.Content-Type",
            }
        }
        method_response = {
            response_models = {}
            response_parameters = {
                "method.response.header.Access-Control-Allow-Origin" = true
                "method.response.header.content-type" = true,
            }
        }
    }
}