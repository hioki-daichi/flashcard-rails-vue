module HasSub
  SEEDS      = '0123456789abcdef'.chars.freeze
  SUB_LENGTH = 7

  extend ActiveSupport::Concern

  included do
    before_create :set_sub

    private

    def set_sub
      value = ::HasSub::SUB_LENGTH.times.map { ::HasSub::SEEDS.sample }.join

      unless self.class.where(sub: value).exists?
        self.sub = value
        return
      end

      set_sub
    end
  end
end
