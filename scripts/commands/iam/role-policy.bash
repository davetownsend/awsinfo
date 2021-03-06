split_args "$@"

ROLES=$(awscli iam list-roles --output text --query "Roles[$(auto_filter RoleName RoleId -- $FIRST_RESOURCE )].[RoleName]")
select_one Role "$ROLES"

ROLE=$SELECTED

ROLES=$(awscli iam list-role-policies --role-name $ROLE --output text --query "PolicyNames[$(filter @ $SECOND_RESOURCE)].[@]")
select_one Policy "$ROLES"

awscli iam get-role-policy --role-name $ROLE --policy-name $SELECTED --output table --query "@.{\"1.Statements\":PolicyDocument.Statement}"