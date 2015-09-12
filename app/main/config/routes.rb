# See https://github.com/voltrb/volt#routes for more info on routes

client '/about', action: 'about'
client '/ticket', action: 'ticket'
client '/pay_ticket', action: 'pay_ticket'
client '/legal', action: 'legal'
client '/court', action: 'court'
client '/your_rights', action: 'your_rights'

# Routes for login and signup, provided by user_templates component gem
# client '/signup', component: 'user_templates', controller: 'signup'
# client '/login', component: 'user_templates', controller: 'login', action: 'index'
# client '/password_reset', component: 'user_templates', controller: 'password_reset', action: 'index'
# client '/forgot', component: 'user_templates', controller: 'login', action: 'forgot'
# client '/account', component: 'user_templates', controller: 'account', action: 'index'

# The main route, this should be last. It will match any params not
# previously matched.
client '/', {}
