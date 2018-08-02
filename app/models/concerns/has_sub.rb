module HasSub
  SEEDS      = '0123456789abcdef'.chars.freeze
  SUB_LENGTH = 7

  extend ActiveSupport::Concern

  included do
    before_create :set_sub

    private

    def set_sub
      sub = generate_sub

      unless self.class.where(sub: sub).exists?
        self.sub = sub
        return
      end

      set_sub
    end

    def generate_sub
      ::HasSub::SUB_LENGTH.times.map { ::HasSub::SEEDS.sample }.join
    end
  end
end
