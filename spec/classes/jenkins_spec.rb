require 'spec_helper'

# Note, rspec-puppet determines the class name from the top level describe
# string.
describe 'jenkins' do
  describe "on RedHat" do
    let(:facts) do
      { :osfamily => 'RedHat', :operatingsystem => 'CentOS' }
    end
    describe 'defalut' do
      it { should contain_class 'jenkins' }
      it { should contain_class 'java' }
      it { should contain_class 'jenkins::repo' }
      it { should contain_class 'jenkins::package' }
      it { should contain_class 'jenkins::config' }
      it { should contain_class 'jenkins::plugins' }
      it { should contain_class 'jenkins::service' }
      it { should contain_class 'jenkins::firewall' }
      it { should contain_class 'jenkins::repo::el' }
      it { should_not contain_class 'jenkins::proxy' }
      it { should_not contain_class 'jenkins::repo::debian' }
    end

    describe 'without java' do
      let(:params) { { :install_java => false } }
      it { should_not contain_class 'java' }
    end

    describe 'without repo' do
      let(:params) { { :repo => false } }
      it { should_not contain_class 'jenkins::repo' }
    end

    describe 'with proxy host' do
      let(:params) { { :proxy_host => '1.2.3.4' } }
      it { should contain_class 'jenkins::proxy'}
    end

    describe 'without firewall' do
      let(:params) { { :configure_firewall => false } }
      it { should_not contain_class 'jenkins::firewall' }
    end
  end

  describe "on Debian" do
    let(:facts) do
      { :osfamily => 'Debian', :lsbdistcodename => 'precise' }
    end
    let :pre_condition do
      " define apt::source (
          $location          = '',
          $release           = $lsbdistcodename,
          $repos             = 'main',
          $include_src       = true,
          $required_packages = false,
          $key               = false,
          $key_server        = 'keyserver.ubuntu.com',
          $key_content       = false,
          $key_source        = false,
          $pin               = false
        ) {
          notify { 'mock apt::source $title':; }
        }
      "
    end

    describe 'default' do
      it { should contain_class 'jenkins' }
      it { should contain_class 'java' }
      it { should contain_class 'jenkins::repo' }
      it { should contain_class 'jenkins::package' }
      it { should contain_class 'jenkins::config' }
      it { should contain_class 'jenkins::plugins' }
      it { should contain_class 'jenkins::service' }
      it { should contain_class 'jenkins::firewall' }
      it { should contain_class 'jenkins::repo::debian' }
      it { should_not contain_class 'jenkins::proxy' }
      it { should_not contain_class 'jenkins::repo::el' }
    end

    describe 'without java' do
      let(:params) { { :install_java => false } }
      it { should_not contain_class 'java' }
    end

    describe 'without repo' do
      let(:params) { { :repo => false } }
      it { should_not contain_class 'jenkins::repo' }
    end

    describe 'with proxy host' do
      let(:params) { { :proxy_host => '1.2.3.4' } }
      it { should contain_class 'jenkins::proxy'}
    end

    describe 'without firewall' do
      let(:params) { { :configure_firewall => false } }
      it { should_not contain_class 'jenkins::firewall' }
    end
  end
end
