#!/usr/bin/env ruby

require 'csv'
require 'time'

require 'win32/eventlog'
require 'win32/mc' # If you want to create message files.

def getSecurityEvent( event_id )

puts case event_id
when 4608 
  return "Startup"
when 4609 
  return "Shutdown"
//when 4624 
//  return "Logon"
//when 4634  
//  return "Logoff"
when 4800  
  return "Lock"
when 4801   
 return "Un-lock"
when 4802    
 return "Screensaver Start"
when 4803
 return "Screensaver End"
else
  return nil
end	

end


def getSystemEvent( event_id )

puts case event_id
when 1 
  return "Awake"
when 42 
  return "Sleep"
when 27 
  return "Un-Dock"
when 32 
  return "Dock"
else
  return nil
end	

end

days = 14;
stopDate = Time.now() - days*24*60*60


CSV.open("/event-log.csv", "wb") do |csv|

event_log = Win32::EventLog.open('Security')
event_log.read(  Win32::EventLog::BACKWARDS_READ | Win32::EventLog::SEQUENTIAL_READ ) do |log|
    
	
	description = getSecurityEvent(log.event_id)
	
	if description.nil?
		next
	end	
	
	p [log.time_generated,log.event_id, log.source, log.category, description]
	
	csv << [log.time_generated,log.event_id, log.source, log.category, description]
	 

	if log.time_generated < stopDate
	  exit 0
	end
	 
end
  

 

  event_log = Win32::EventLog.open('System')
  event_log.read(  Win32::EventLog::BACKWARDS_READ | Win32::EventLog::SEQUENTIAL_READ ) do |log|
    
	
  description = getSystemEvent(log.event_id)
	
	if description.nil?
		next
	end	
	
	p [log.time_generated,log.event_id, log.category, description]
	
	csv << [log.time_generated,log.event_id, log.category, description]
	 

  if log.time_generated < stopDate
    exit 0
  end
	 
	 
	 
	 
end
  

 
end