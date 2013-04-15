# encoding: UTF-8
module Markdown
  module Render
    class HTML < MdEmoji::Render #Redcarpet::Render::HTML
      def block_code(code, language)
        sha = Digest::SHA1.hexdigest(code)
        Rails.cache.fetch ["code", language, sha].join("-") do
          CodeRay.scan(code, language).div#(:line_numbers => :table)
        end
      end
    end
  end
end



