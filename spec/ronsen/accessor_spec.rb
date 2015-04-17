require 'spec_helper'

describe Ronsen::Accessor do
  it 'can get some xml' do
    accessor = Ronsen::Accessor.instance
    response = accessor.get_programs_xml
    expect(response).to match(/xml/)
  end
end
