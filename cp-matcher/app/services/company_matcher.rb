class CompanyMatcher
    class PrefixNotFound < StandardError; end
    class CompanyNotFoundInDB < StandardError; end

    COMPANY_PREFIX = "VND-"
    COMPANY_REGEX = /VND-\w{4,20}/

    # this function finds in a text a company code based on COMPANY_REGEX
    # and matches it against the company table in the database
    def self.fuzzy_search(text)
        begin
            results = text.match(COMPANY_REGEX)
            raise PrefixNotFound if !results

            # fuzzy search in database for the company name
            companies = Company.search_name(results[0].sub(COMPANY_PREFIX, ''))
            raise CompanyNotFoundInDB if companies.length == 0

            companies[0].name
        rescue PrefixNotFound
            nil
        rescue CompanyNotFoundInDB
            nil
        end

    end
end