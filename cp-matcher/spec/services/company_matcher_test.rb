require "rails_helper"

RSpec.describe CompanyMatcher do
  context "multiple matches in text" do
    let(:text) { "This is the first company #{CompanyMatcher::COMPANY_PREFIX}GOOGLE and a second Company #{CompanyMatcher::COMPANY_PREFIX}MICROSOFT"}

    it "should match bsed on the first result" do
        expect(CompanyMatcher.fuzzy_search(text)).to eq "GOOGLE"
    end
  end
end