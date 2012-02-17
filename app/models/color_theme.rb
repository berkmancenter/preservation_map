class ColorTheme < ActiveRecord::Base
    serialize :gradient

    acts_as_api

    api_accessible :gradient_only do |template|
        template.add :gradient
    end
end
