require 'spec_helper'

describe Ronsen::Accessor do
  it 'can get some xml' do
    accessor = Ronsen::Accessor.new
    response = accessor.get_xml(1)
    expect(response).to match(/xml/)
  end
end
