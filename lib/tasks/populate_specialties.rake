# frozen_string_literal: true

namespace :db do # ~> NoMethodError: undefined method `namespace' for main:Object
  namespace :populate do
    task specialties: [:environment] do
      @log = Logger.new("log/specialties.log")
      @stdout = Logger.new(STDOUT)
      Person.where.not(specialties: nil).each do |p|
        # stdout_and_log("#{p.label}")
        s = p.specialties
        s = s.gsub("--- []","")
        s = s.gsub("---\n- ","")
        s = s.gsub("\n- ","|")
        s = s.gsub("\n","")
        s = s.split("|")
        s = s.reject(&:empty?)

        s.each do |sp|
          p.subjects.push Subject.find_by(name: sp)
        end if s.first != " []"
        
        p.save!
      end
    end
  end
end

def stdout_and_log(message, level: :info)
  @log.send(level, message)
  @stdout.send(level, message)
end