class ColorTheme < ActiveRecord::Base
    serialize :gradient

    attr_accessible :gradient
end
