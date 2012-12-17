dep 'java.managed' do
  installs {
    via :apt, 'openjdk-7-jdk'
  }
end