FROM muhq/pyinstaller-windows

COPY Dockerfiles/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
