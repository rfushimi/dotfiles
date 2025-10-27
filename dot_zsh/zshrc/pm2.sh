#!/bin/zsh

# pm2 status display (deferred to not block p10k instant prompt)
# if command -v pm2 &> /dev/null; then
#     # Use precmd hook to run after first prompt is displayed
#     _pm2_status_shown=0

#     _show_pm2_status() {
#         if (( _pm2_status_shown == 0 )); then
#             _pm2_status_shown=1
#             # Run in background to not block prompt
#             {
#                 echo ""
#                 pm2 status
#             } &!
#             # Remove this hook after first execution
#             precmd_functions=(${precmd_functions:#_show_pm2_status})
#         fi
#     }

#     # Add to precmd hooks (runs after each command, before prompt)
#     precmd_functions+=(_show_pm2_status)
# fi
