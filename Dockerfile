FROM dockernano/crosstool-ng

RUN apt-get update && apt-get install -y subversion
