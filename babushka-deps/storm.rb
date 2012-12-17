dep 'storm.source' do
  requires 'zeromq-2.1.7.source', 'jzmq-nathanmarz.source', 'zookeeper-started'
  met? {
    "/opt/storm-0.8.1".p.exists?.tap {|result|
      log "met?: #{result}."
    }
  }
  meet {
    shell <<-EOH
  cd /opt
  mkdir mnt-storm || true
  rm -rf storm-0.8.1* || true
  wget https://github.com/downloads/nathanmarz/storm/storm-0.8.1.zip
  unzip storm-0.8.1.zip
  rm storm-0.8.1.zip
    EOH
    log "installed storm from the sources."
  }
end

dep 'zeromq-2.1.7.source' do
  requires 'zeromq_jzmq_build.managed'
  met? {
    "/usr/local/lib/libzmq.so".p.exists?.tap {|result|
      log "met?: #{result}."
    }
  }
  meet {
    shell <<-EOH
    cd /tmp
    rm -rf zeromq-2.1.7 || true
    curl -O http://download.zeromq.org/zeromq-2.1.7.tar.gz
    tar -xzvf zeromq-2.1.7.tar.gz
    cd zeromq-2.1.7
    ./configure
    make
    make install
    EOH
    log "installed zeromq-2.1.7 from the sources."
  }
end

dep 'jzmq-nathanmarz.source' do
  requires 'zeromq_jzmq_build.managed'
  met? {
    "/usr/local/lib/libjzmq.so".p.exists?.tap {|result|
      log "met?: #{result}."
    }
  }
  meet {
    shell <<-EOH
  export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64
  cd /tmp
  rm -rf jzmq || true
git clone --depth 1 https://github.com/nathanmarz/jzmq.git
cd jzmq
./autogen.sh
./configure
touch src/classdist_noinst.stamp
cd src/
CLASSPATH=.:./.:$CLASSPATH javac -d . org/zeromq/ZMQ.java org/zeromq/App.java org/zeromq/ZMQForwarder.java org/zeromq/EmbeddedLibraryTools.java org/zeromq/ZMQQueue.java org/zeromq/ZMQStreamer.java org/zeromq/ZMQException.java
cd ..
make
make install
    EOH
    log "installed jzmq from the sources."
  }
end

dep 'zeromq_jzmq_build.managed' do
  requires 'java.managed'
  installs {
    via :apt, 'unzip', 'build-essential', 'pkg-config', 'libtool',
              'autoconf', 'uuid-dev', 'python-dev'
  }
  provides [ 'unzip' ]
end

dep 'zookeeper.managed' do
  installs {
    via :apt, 'zookeeper'
  }
  provides [ 'zooinspector' ]
end

dep 'zookeeper-sysv-daemon' do
  requires 'zookeeper.managed'
  met? {
    "/etc/init.d/zookeeper".p.exists?.tap {|result|
      log "met?: #{result}."
    }
  }
  meet {
    shell <<-EOH
      ln -s /usr/share/zookeeper/bin/zkServer.sh /etc/init.d/zookeeper
    EOH
  }
end

dep 'zookeeper-started' do
  requires 'zookeeper-sysv-daemon'
  met? {
    shell "/etc/init.d/zookeeper status"
  }
  meet {
    shell "/etc/init.d/zookeeper start"
  }
end


