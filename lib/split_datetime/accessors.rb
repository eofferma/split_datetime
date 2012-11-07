module SplitDatetime
  module Accessors

    def accepts_split_time_for(*attrs)
      opts = { format: "%F", default: lambda { Time.now.change(min: 0) } }

      if attrs.last.class == Hash
        custom = attrs.delete_at(-1)
        opts = opts.merge(custom)
      end

      attrs.each do |attr|
        attr_accessible "#{attr}(1i)", "#{attr}(2i)", "#{attr}(3i)", "#{attr}(4i)", "#{attr}(5i)"

        define_method("#{attr}(1i)=") do |year|
          datetime = self.send(attr) || opts[:default].call
          self.send("#{attr}=", datetime.change(year: year))
        end

        define_method("#{attr}(2i)=") do |month|
          datetime = self.send(attr) || opts[:default].call
          self.send("#{attr}=", datetime.change(month: month))
        end

        define_method("#{attr}(3i)=") do |day|
          datetime = self.send(attr) || opts[:default].call
          self.send("#{attr}=", datetime.change(day: day))
        end

        define_method("#{attr}(4i)=") do |hour|
          datetime = self.send(attr) || opts[:default].call
          self.send("#{attr}=", datetime.change(hour: hour))
        end

        define_method("#{attr}(5i)=") do |min|
          datetime = self.send(attr) || opts[:default].call
          self.send("#{attr}=", datetime.change(min: min))
        end

        define_method("#{attr}(1i)") do
          self.send(attr).year unless self.send(attr).nil?
        end

        define_method("#{attr}(2i)") do
          self.send(attr).month unless self.send(attr).nil?
        end

        define_method("#{attr}(3i)") do
          self.send(attr).day unless self.send(attr).nil?
        end

        define_method("#{attr}(4i)") do
          self.send(attr).hour unless self.send(attr).nil?
        end

        define_method("#{attr}(5i)") do
          self.send(attr).min unless self.send(attr).nil?
        end

      end
    end

    def accepts_split_datetime_for(*attrs)
      opts = { format: "%F", default: lambda { Time.now.change(min: 0) } }

      if attrs.last.class == Hash
        custom = attrs.delete_at(-1)
        opts = opts.merge(custom)
      end

      attrs.each do |attr|
        attr_accessible "#{attr}_date", "#{attr}_hour", "#{attr}_min"

        define_method(attr) do
          super() || opts[:default].call
        end

        define_method("#{attr}_date=") do |date|
          date = Date.parse(date.to_s)
          self.send("#{attr}=", self.send(attr).change(year: date.year, month: date.month, day: date.day))
        end

        define_method("#{attr}_hour=") do |hour|
          self.send("#{attr}=", self.send(attr).change(hour: hour, min: self.send(attr).min))
        end

        define_method("#{attr}_min=") do |min|
          self.send("#{attr}=", self.send(attr).change(min: min))
        end

        define_method("#{attr}_date") do
          self.send(attr).strftime(opts[:format]) unless self.send(attr).nil?
        end

        define_method("#{attr}_hour") do
          self.send(attr).hour unless self.send(attr).nil?
        end

        define_method("#{attr}_min") do
          self.send(attr).min unless self.send(attr).nil?
        end
      end
    end
  end
end
