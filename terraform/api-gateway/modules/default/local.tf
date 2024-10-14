locals {

    proxy = var.apply_response_script ? local.proxy_with_scripts : local.proxy_without_scripts

    proxy_without_scripts = {
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
            type = "HTTP_PROXY"
            request_parameters = {
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
                "application/json" = "{ statusCode: 200 }"
            }
        }
        integration_response = {
            integration_response_status_code = "200"
            response_templates = {}
            response_parameters = {}
        }
        method_response = {
            response_models = {
                "application/json" = "Empty"
            }
            response_parameters = {}
            status_code = "200"
        }
    }

    proxy_with_scripts = {
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
                "integration.request.header.userid" = "context.authorizer.userId"
                "integration.request.header.token" = "''"
                "integration.request.header.Accept-Encoding" = "'identity'"
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
        integration_get = {
            uri = "${var.load_balancer}/{proxy}"
            type = "HTTP"
            request_parameters = {
                "integration.request.header.userid" = "context.authorizer.userId"
                "integration.request.header.token" = "''"
                "integration.request.header.Accept-Encoding" = "'identity'"
                "integration.request.header.x-http-method-override" = "'GET'"
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
            status_code = {
                "200" = "20[0-35-9]",
                "201" = "201",
                "204" = "204" ,
                "400" = "40[0-25-9]",
                "403" = "403",
                "404" = "404",
                "500" = "5*"
            }
            response_templates = {}
            response_parameters = {
                "method.response.header.Access-Control-Allow-Origin" = "'*'",
                "method.response.header.content-type"                = "integration.response.header.Content-Type",
                "method.response.header.Content-Encoding"            = "integration.response.header.Content-Encoding",
                "method.response.header.Vary"                        = "integration.response.header.Vary",
                "method.response.header.Transfer-Encoding"           = "integration.response.header.Transfer-Encoding",
                "method.response.header.Content-Disposition"         = "integration.response.header.Content-Disposition",
            }
        }
        method_response = {
            status_code = {
                "200" = "20[0-35-9]",
                "201" = "201",
                "204" = "204" ,
                "400" = "40[0-25-9]",
                "403" = "403",
                "404" = "404",
                "500" = "5*"
            }
            response_models = {}
            response_parameters = {
                "method.response.header.Access-Control-Allow-Origin" = true
                "method.response.header.content-type"                = true,
                "method.response.header.Content-Encoding"            = true,
                "method.response.header.Vary"                        = true,
                "method.response.header.Transfer-Encoding"           = true,
                "method.response.header.Content-Disposition"         = true,
            }
        }
    }
}