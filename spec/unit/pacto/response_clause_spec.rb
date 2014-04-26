module Pacto
  describe ResponseClause do
    let(:body_definition) do
      {
        :type => 'object',
        :required => true,
        :properties => double('body definition properties')
      }
    end

    let(:definition) do
      {
        'status' => 200,
        'headers' => {
          'Content-Type' => 'application/json'
        },
        'schema' => body_definition
      }
    end

    subject(:response) { ResponseClause.new(definition) }

    it 'has a status' do
      expect(response.status).to eq(200)
    end

    it 'has a headers hash' do
      expect(response.headers).to eq(
        'Content-Type' => 'application/json'
      )
    end

    it 'has a schema' do
      expect(response.schema).to eq(body_definition)
    end

    it 'has a default value for the schema' do
      definition.delete 'schema'
      response = ResponseClause.new(definition)
      expect(response.schema).to eq(Hash.new)
    end

    describe 'the response body' do
      let(:generated_body) { double }

      it 'is the json generated from the schema' do
        JSON::Generator.should_receive(:generate).
          with(definition['schema']).
          and_return(generated_body)

        expect(response.body).to eq(generated_body)
      end
    end
  end
end
