require_relative 'support/matchers/whitespace_matcher'

RSpec.configure do |config|
  config.include WhitespaceMatchers
end

FILES_TO_IGNORE = %Q{ ./.gitmodules
                      ./tags
                      ./public/favicon.ico
                      ./gems.tags
                      ./lib/data/macys-all.json
                      ./.DS_Store
                      ./app/.DS_Store
                      ./app/assets/.DS_Store
                    }

describe "The application itself" do
  it "has no malformed whitespace" do
    #List all files in the directory outside of ./.git, ./log, and ./tmp that aren't included in
    #the FILES_TO_IGNORE listing.
    files = `find . -type d \\( -path ./.git -o -path ./log -o -path ./tmp -o -path ./vendor -o -path ./app/assets/fonts -o -path ./app/assets/images -o -path ./lib/data \\) -prune -o -print`.split("\n").find_all do |filename|
     !FILES_TO_IGNORE.include?(filename)
    end

    #Ensure each of those files has no trailing whitespace or tabs
    files.should be_well_formed
  end
end
