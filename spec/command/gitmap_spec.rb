require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Gitmap do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ gitmap }).should.be.instance_of Command::Gitmap
      end
    end
  end
end

