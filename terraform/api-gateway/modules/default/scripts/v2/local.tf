locals {

    proxy = {
        method = {
            authorization = "CUSTOM"
            authorizer_id = var.custom_authorizer
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
            status_code = {"200" : ""}
        }
    }
}


