from ubuntu:17.10

RUN \
	apt-get update; \
	apt-get install -y \
		automake \
		autotools-dev \
		bsdmainutils \
		build-essential \
		curl \
		git \
		libevent-dev \
		libboost-all-dev \
		libssl-dev \
		libtool \
		libminiupnpc-dev \
		pkg-config \
		python3 \
		qt5-default \
		wget

ENV BITCOIN_ROOT /bitcoin

ENV BDB_PREFIX $BITCOIN_ROOT/db4

RUN \
	mkdir -p $BDB_PREFIX && \
	wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz' && \
	echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-4.8.30.NC.tar.gz' | sha256sum -c && \
	tar -xzvf db-4.8.30.NC.tar.gz && \
	cd db-4.8.30.NC/build_unix/ && \
	../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$BDB_PREFIX && \
	make install

COPY . $BITCOIN_ROOT/DigitalPriceClassic

ENV BDB_INCLUDE_PATH /bitcoin/db4/include

ENV BDB_LIB_PATH /bitcoin/db4/lib

RUN cd $BITCOIN_ROOT/DigitalPriceClassic/src && \
	make -f makefile.unix

CMD $BITCOIN_ROOT/DigitalPriceClassic/src/DigitalPriced
