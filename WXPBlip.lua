-- Represents a blip comprised of a Frame, a FontString (the blip's label) attached to the frame, and a Texture (the blip's dot)
-- Frames can never be deleted, so when a new blip is needed, we first try returning the first unused blip before creating a new one

WXPBlip = {}
WXPBlip.instances = {}
WXPBlip.__index = WXPBlip
WXPBlip.debug = "|cffff0080[Blip]|r"

--- Class functions ---

function WXPBlip.new()		-- Create a new blip
	WXP.Debug(WXPBlip.debug, "Creating new blip")
	local self = {}
	self.id = #WXPBlip.instances + 1
	setmetatable(self, WXPBlip)
	tinsert(WXPBlip.instances, self)
	
	self.orientation = "right"
	self.free = false
	
	self.frame = CreateFrame("Frame", "WXP_Frame_"..self.id, WXP_Frame, nil, self.id)
	self.frame:SetPoint("CENTER", WXP_Frame, "LEFT", 0, WXP_Settings.blip.offset.y)
	self.frame:SetSize(WXP_Settings.blip.size, WXP_Settings.blip.size)
	self.frame:SetScript("OnEnter", WXP.OnBlipMouseEnter)
	self.frame:SetScript("OnLeave", WXP.OnBlipMouseLeave)
	self.frame.blip = self
	
	self.texture = self.frame:CreateTexture("WXP_Tex_"..self.id,"ARTWORK")
	self.texture:SetTexture(WXP_Settings.blip.texture)
	self.texture:SetTexCoord(WXP_Settings.blip.texoffset.x1, WXP_Settings.blip.texoffset.x2,WXP_Settings.blip.texoffset.y1,WXP_Settings.blip.texoffset.y2)
	self.texture:SetAllPoints()
	
	self.fontstring = self.frame:CreateFontString("WXP_Text_"..self.id,"ARTWORK","GameFontNormal")
	
	return self
end

function WXPBlip.GetFree()	-- Get the first free blip, or create one if none are free
	WXP.Debug(WXPBlip.debug, "Finding first free blip")
	for i,blip in ipairs(WXPBlip.instances) do
		if blip.free then
			WXP.Debug(WXPBlip.debug, "Blip #"..i, "is free")
			blip.free = false
			return blip
		end
	end
	
	-- None free, so create a new blip
	WXP.Debug(WXPBlip.debug, "No free blips, creating a new one")
	return WXPBlip.new()
end
