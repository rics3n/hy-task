require "rails_helper"

RSpec.describe Company, :type => :model do
  context "pre conditions" do
    it "should have multiple preexisting companies" do
      expect(Company.count).to be > 1
    end
  end

  context "create a new company" do
    it "should create a company with a name" do
      name = "Test"
      cp = Company.create!(name: name)

      expect(cp.name).to eq(name)
    end

    it 'should enforce uniqueness of company name' do
      name = "Test"
      cp = Company.create!(name: name)      
      expect { Company.create!(name: name) }.to raise_error
    end

    it "should not save a company without a name" do
      expect { Company.create! }.to raise_error
    end
  end

  context "fuzzy search for company" do
    let(:no_match) { "HASPA" }
    let(:too_fuzzy) { "GL" }

    companies = ["GOOGLE", "GOGLE", "G00GLE", "M1CROSOFT", "MICROSOFT", "MICROFOST", "MICROSOFT"]
    companies.each do |company|
      it "should find the company even if there are spelling mistakes (#{company})" do
        expect(Company.search_name(company).length).to eq 1
      end
    end

    it "should return nil if nothig matched" do
        expect(Company.search_name(no_match).length).to eq 0
    end

    it "should return nil if the company is too far away from the actual spelling" do
      expect(Company.search_name(too_fuzzy).length).to eq 0
    end
  end

end