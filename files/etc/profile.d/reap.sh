# Ensure that all shells respond to signals when the container is terminated
trap exit TERM KILL
