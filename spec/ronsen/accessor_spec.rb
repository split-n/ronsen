require 'spec_helper'

describe Ronsen::Accessor do
  it 'can get soreppoi xml' do
    accessor = Ronsen::Accessor.instance
    response = accessor.get_programs_xml
    expect(response.scan("<title>").count).to be > 10
    expect(response.scan(/\<movie_url\>http.+\/.+\.\w+\<\/movie_url\>/).count).to be > 10
  end
end
