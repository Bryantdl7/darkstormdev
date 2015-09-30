--/*-------------------------------------------------------------------------------------------------------------------------
--Freeze every prop/player/LightEnt. on the server!
--Made By HeLLFox_15,
--edited by Bryantdl7 to work in xgui nicer
--Improved by Ligitmenty (Note: THIS IS A SNAPSHOT PRODUCT, EXPECT BUGS)
---------------------------------------------------------------------------------------------------------------------------*/

local CATEGORY_NAME = "Utility"
function ulx.nolag( calling_ply )
        local Ent = ents.FindByClass("prop_physics")
                for _,Ent in pairs(Ent) do
                        if Ent:IsValid() then
                                local phys = Ent:GetPhysicsObject()
                                phys:EnableMotion(False)
                        end
                end

		local Ent2 = ents.FindByClass("gmod_balloon")
				for _,Ent2 in pairs(Ent2) do	
						if Ent2:IsValid() then
							local phys2 = Ent2:GetPhysicsObject()
							phys2:EnableMotion(False)
						end
				end
				
		local Ent3 = ents.FindByClass("gmod_light")
				for _,Ent3 in pairs(Ent3) do
						if Ent3:IsValid() then
							local phys3 = Ent3:GetPhysicsObject()
							phys3:EnableMotion(False)
						end
				end
				
		local Ent4 = ents.FindByClass("gmod_lamp")
				for _,Ent4 in pairs(Ent4) do
						if Ent4:IsValid() then
							local phys4 = Ent4:GetPhysicsObject()
							phys4:EnableMotion(False)
						end
				end
				
		local Ent5 = ents.FindByClass("gmod_thruster")
				for _,Ent5 in pairs(Ent5) do
						if Ent5:IsValid() then
							local phys5 = Ent5:GetPhysicsObject()
							phys5:EnableMotion(False)
						end
				end
		
		local Ent6 = ents.FindByClass("gmod_wire_thruster")
				for _,Ent6 in pairs(Ent6) do
						if Ent6:IsValid() then
							local phys6 = Ent6:GetPhysicsObject()
							phys6:EnableMotion(False)
						end
				end
				
		local Ent7 = ents.FindByClass("gmod_wire_light")
				for _,Ent7 in pairs(Ent7) do
						if Ent7:IsValid() then
							local phys7 = Ent7:GetPhysicsObject()
							phys7:EnableMotion(False)
						end
				end
				
		local Ent8 = ents.FindByClass("gmod_wire_lamp")
				for _,Ent8 in pairs(Ent8) do
						if Ent8:IsValid() then
							local phys8 = Ent8:GetPhysicsObject()
							phys8:EnableMotion(False)
						end
				end
--Extra Stuff Below This Line (Wiremod ect...)
		local Ent9 = ents.FindByClass("gmod_wire_vectorthruster")
				for _,Ent9 in pairs(Ent9) do
						if Ent9:IsValid() then
							local phys9 = Ent9:GetPhysicsObject()
							phys9:EnableMotion(False)
						end
				end
		
		local Ent10 = ents.FindByClass("gmod_wire_wheel")
				for _,Ent10 in pairs(Ent10) do
						if Ent10:IsValid() then
							local phys10 = Ent10:GetPhysicsObject()
							phys10:EnableMotion(False)
						end
				end
				
		local Ent11 = ents.FindByClass("gmod_wire_vehicle")
				for _,Ent11 in pairs(Ent11) do
						if Ent11:IsValid() then
							local phys11 = Ent11:GetPhysicsObject()
							phys11:EnableMotion(False)
						end
				end
				
		local Ent12 = ents.FindByClass("gmod_wire_indicator")
				for _,Ent12 in pairs(Ent12) do
						if Ent12:IsValid() then
							local phys12 = Ent12:GetPhysicsObject()
							phys12:EnableMotion(False)
						end
				end
				
		local Ent13 = ents.FindByClass("gmod_wire_textscreen")
				for _,Ent13 in pairs(Ent13) do
						if Ent13:IsValid() then
							local phys13 = Ent13:GetPhysicsObject()
							phys13:EnableMotion(False)
						end
				end
				
		local Ent14 = ents.FindByClass("gmod_wire_addressbus")
				for _,Ent14 in pairs(Ent14) do
						if Ent14:IsValid() then
							local phys14 = Ent14:GetPhysicsObject()
							phys14:EnableMotion(False)
						end
				end
				
		local Ent15 = ents.FindByClass("gmod_wire_adv_emarker")
				for _,Ent15 in pairs(Ent15) do
						if Ent15:IsValid() then
							local phys15 = Ent15:GetPhysicsObject()
							phys15:EnableMotion(False)
						end
				end
		
		local Ent16 = ents.FindByClass("gmod_wire_adv_input")
				for _,Ent16 in pairs(Ent16) do
						if Ent16:IsValid() then
							local phys16 = Ent16:GetPhysicsObject()
							phys16:EnableMotion(False)
						end
				end
				
		local Ent17 = ents.FindByClass("gmod_wire_button")
				for _,Ent17 in pairs(Ent17) do
						if Ent17:IsValid() then
							local phys17 = Ent17:GetPhysicsObject()
							phys17:EnableMotion(False)
						end
				end
				
		local Ent18 = ents.FindByClass("gmod_wire_button")
				for _,Ent18 in pairs(Ent18) do
						if Ent18:IsValid() then
							local phys18 = Ent18:GetPhysicsObject()
							phys18:EnableMotion(False)
						end
				end
				
		local Ent19 = ents.FindByClass("gmod_wire_cameracontroller")
				for _,Ent19 in pairs(Ent19) do
						if Ent19:IsValid() then
							local phys19 = Ent19:GetPhysicsObject()
							phys19:EnableMotion(False)
						end
				end
				
		local Ent20 = ents.FindByClass("gmod_wire_cd_disk")
				for _,Ent20 in pairs(Ent20) do
						if Ent20:IsValid() then
							local phys20 = Ent20:GetPhysicsObject()
							phys20:EnableMotion(False)
						end
				end
				
		local Ent21 = ents.FindByClass("gmod_wire_clutch")
				for _,Ent21 in pairs(Ent21) do
						if Ent21:IsValid() then
							local phys21 = Ent21:GetPhysicsObject()
							phys21:EnableMotion(False)
						end
				end
				
		local Ent22 = ents.FindByClass("gmod_wire_colorer")
				for _,Ent22 in pairs(Ent22) do
						if Ent22:IsValid() then
							local phys22 = Ent22:GetPhysicsObject()
							phys22:EnableMotion(False)
						end
				end
				
		local Ent23 = ents.FindByClass("gmod_wire_consolescreen")
				for _,Ent23 in pairs(Ent23) do
						if Ent23:IsValid() then
							local phys23 = Ent23:GetPhysicsObject()
							phys23:EnableMotion(False)
						end
				end
				
		local Ent24 = ents.FindByClass("gmod_wire_cpu")
				for _,Ent24 in pairs(Ent24) do
						if Ent24:IsValid() then
							local phys24 = Ent24:GetPhysicsObject()
							phys24:EnableMotion(False)
						end
				end
				
		local Ent25 = ents.FindByClass("gmod_wire_damage_detector")
				for _,Ent25 in pairs(Ent25) do
						if Ent25:IsValid() then
							local phys25 = Ent25:GetPhysicsObject()
							phys25:EnableMotion(False)
						end
				end
				
		local Ent26 = ents.FindByClass("gmod_wire_data_satellitedish")
				for _,Ent26 in pairs(Ent26) do
						if Ent26:IsValid() then
							local phys26 = Ent26:GetPhysicsObject()
							phys26:EnableMotion(False)
						end
				end
				
		local Ent27 = ents.FindByClass("gmod_wire_data_store")
				for _,Ent27 in pairs(Ent27) do
						if Ent27:IsValid() then
							local phys27 = Ent27:GetPhysicsObject()
							phys27:EnableMotion(False)
						end
				end
				
		local Ent28 = ents.FindByClass("gmod_wire_data_transferer")
				for _,Ent28 in pairs(Ent28) do
						if Ent28:IsValid() then
							local phys28 = Ent28:GetPhysicsObject()
							phys28:EnableMotion(False)
						end
				end
				
		local Ent29 = ents.FindByClass("gmod_wire_datasocket")
				for _,Ent29 in pairs(Ent29) do
						if Ent29:IsValid() then
							local phys29 = Ent29:GetPhysicsObject()
							phys29:EnableMotion(False)
						end
				end
				
		local Ent30 = ents.FindByClass("gmod_wire_dataport")
				for _,Ent30 in pairs(Ent30) do
						if Ent30:IsValid() then
							local phys30 = Ent30:GetPhysicsObject()
							phys30:EnableMotion(False)
						end
				end
				
		local Ent31 = ents.FindByClass("gmod_wire_datarate")
				for _,Ent31 in pairs(Ent31) do
						if Ent31:IsValid() then
							local phys31 = Ent31:GetPhysicsObject()
							phys31:EnableMotion(False)
						end
				end
				
		local Ent32 = ents.FindByClass("gmod_wire_detonator")
				for _,Ent32 in pairs(Ent32) do
						if Ent32:IsValid() then
							local phys32 = Ent32:GetPhysicsObject()
							phys32:EnableMotion(False)
						end
				end
				
		local Ent33 = ents.FindByClass("gmod_wire_detonator")
				for _,Ent33 in pairs(Ent33) do
						if Ent33:IsValid() then
							local phys33 = Ent33:GetPhysicsObject()
							phys33:EnableMotion(False)
						end
				end
				
		local Ent34 = ents.FindByClass("gmod_wire_dhdd")
				for _,Ent34 in pairs(Ent34) do
						if Ent34:IsValid() then
							local phys34 = Ent34:GetPhysicsObject()
							phys34:EnableMotion(False)
						end
				end
				
		local Ent35 = ents.FindByClass("gmod_wire_digitalscreen")
				for _,Ent35 in pairs(Ent35) do
						if Ent35:IsValid() then
							local phys35 = Ent35:GetPhysicsObject()
							phys35:EnableMotion(False)
						end
				end
				
		local Ent36 = ents.FindByClass("gmod_wire_dual_input")
				for _,Ent36 in pairs(Ent36) do
						if Ent36:IsValid() then
							local phys36 = Ent36:GetPhysicsObject()
							phys36:EnableMotion(False)
						end
				end
				
		local Ent37 = ents.FindByClass("gmod_wire_dynamic_button")
				for _,Ent37 in pairs(Ent37) do
						if Ent37:IsValid() then
							local phys37 = Ent37:GetPhysicsObject()
							phys37:EnableMotion(False)
						end
				end
				
		local Ent37 = ents.FindByClass("gmod_wire_egp")
				for _,Ent37 in pairs(Ent37) do
						if Ent37:IsValid() then
							local phys37 = Ent37:GetPhysicsObject()
							phys37:EnableMotion(False)
						end
				end
				
		local Ent38 = ents.FindByClass("gmod_wire_emarker")
				for _,Ent38 in pairs(Ent38) do
						if Ent38:IsValid() then
							local phys38 = Ent38:GetPhysicsObject()
							phys38:EnableMotion(False)
						end
				end
				
		local Ent39 = ents.FindByClass("gmod_wire_exit_point")
				for _,Ent39 in pairs(Ent39) do
						if Ent39:IsValid() then
							local phys39 = Ent39:GetPhysicsObject()
							phys39:EnableMotion(False)
						end
				end
						
		local Ent40 = ents.FindByClass("gmod_wire_explosive")
				for _,Ent40 in pairs(Ent40) do
						if Ent40:IsValid() then
							local phys40 = Ent40:GetPhysicsObject()
							phys40:EnableMotion(False)
						end
				end
								
		local Ent41 = ents.FindByClass("gmod_wire_expression2")
				for _,Ent41 in pairs(Ent41) do
						if Ent41:IsValid() then
							local phys41 = Ent41:GetPhysicsObject()
							phys41:EnableMotion(False)
						end
				end
								
		local Ent42 = ents.FindByClass("gmod_wire_extbus")
				for _,Ent42 in pairs(Ent42) do
						if Ent42:IsValid() then
							local phys42 = Ent42:GetPhysicsObject()
							phys42:EnableMotion(False)
						end
				end
										
		local Ent43 = ents.FindByClass("gmod_wire_eyepod")
				for _,Ent43 in pairs(Ent43) do
						if Ent43:IsValid() then
							local phys43 = Ent43:GetPhysicsObject()
							phys43:EnableMotion(False)
						end
				end
				
		local Ent44 = ents.FindByClass("gmod_wire_forcer")
				for _,Ent44 in pairs(Ent44) do
						if Ent44:IsValid() then
							local phys44 = Ent44:GetPhysicsObject()
							phys44:EnableMotion(False)
						end
				end
				
		local Ent45 = ents.FindByClass("gmod_wire_freezer")
				for _,Ent45 in pairs(Ent45) do
						if Ent45:IsValid() then
							local phys45 = Ent45:GetPhysicsObject()
							phys45:EnableMotion(False)
						end
				end
				
		local Ent46 = ents.FindByClass("gmod_wire_fx_emitter")
				for _,Ent46 in pairs(Ent46) do
						if Ent46:IsValid() then
							local phys46 = Ent46:GetPhysicsObject()
							phys46:EnableMotion(False)
						end
				end
						
		local Ent47 = ents.FindByClass("gmod_wire_gate")
				for _,Ent47 in pairs(Ent47) do
						if Ent47:IsValid() then
							local phys47 = Ent47:GetPhysicsObject()
							phys47:EnableMotion(False)
						end
				end
				
		local Ent48 = ents.FindByClass("gmod_wire_gimbal")
				for _,Ent48 in pairs(Ent48) do
						if Ent48:IsValid() then
							local phys48 = Ent48:GetPhysicsObject()
							phys48:EnableMotion(False)
						end
				end
				
		local Ent49 = ents.FindByClass("gmod_wire_gps")
				for _,Ent49 in pairs(Ent49) do
						if Ent49:IsValid() then
							local phys49 = Ent49:GetPhysicsObject()
							phys49:EnableMotion(False)
						end
				end
				
		local Ent50 = ents.FindByClass("gmod_wire_gpu")
				for _,Ent50 in pairs(Ent50) do
						if Ent50:IsValid() then
							local phys50 = Ent50:GetPhysicsObject()
							phys50:EnableMotion(False)
						end
				end
				
		local Ent51 = ents.FindByClass("gmod_wire_gpulib_controller")
				for _,Ent51 in pairs(Ent51) do
						if Ent51:IsValid() then
							local phys51 = Ent51:GetPhysicsObject()
							phys51:EnableMotion(False)
						end
				end
		
		local Ent52 = ents.FindByClass("gmod_wire_grabber")
				for _,Ent52 in pairs(Ent52) do
						if Ent52:IsValid() then
							local phys52 = Ent52:GetPhysicsObject()
							phys52:EnableMotion(False)
						end
				end
				
		local Ent53 = ents.FindByClass("gmod_wire_graphics_tablet")
				for _,Ent53 in pairs(Ent53) do
						if Ent53:IsValid() then
							local phys53 = Ent53:GetPhysicsObject()
							phys53:EnableMotion(False)
						end
				end
				
		local Ent54 = ents.FindByClass("gmod_wire_gyroscope")
				for _,Ent54 in pairs(Ent54) do
						if Ent54:IsValid() then
							local phys54 = Ent54:GetPhysicsObject()
							phys54:EnableMotion(False)
						end
				end
				
		local Ent55 = ents.FindByClass("gmod_wire_hdd")
				for _,Ent55 in pairs(Ent55) do
						if Ent55:IsValid() then
							local phys55 = Ent55:GetPhysicsObject()
							phys55:EnableMotion(False)
						end
				end
				
		local Ent56 = ents.FindByClass("gmod_wire_holoemitter")
				for _,Ent56 in pairs(Ent56) do
						if Ent56:IsValid() then
							local phys56 = Ent56:GetPhysicsObject()
							phys56:EnableMotion(False)
						end
				end
				
		local Ent57 = ents.FindByClass("gmod_wire_hologrid")
				for _,Ent57 in pairs(Ent57) do
						if Ent57:IsValid() then
							local phys57 = Ent57:GetPhysicsObject()
							phys57:EnableMotion(False)
						end
				end
				
		local Ent58 = ents.FindByClass("gmod_wire_hoverball")
				for _,Ent58 in pairs(Ent58) do
						if Ent58:IsValid() then
							local phys58 = Ent58:GetPhysicsObject()
							phys58:EnableMotion(False)
						end
				end
				
		local Ent59 = ents.FindByClass("gmod_wire_hudindicator")
				for _,Ent59 in pairs(Ent59) do
						if Ent59:IsValid() then
							local phys59 = Ent59:GetPhysicsObject()
							phys59:EnableMotion(False)
						end
				end
				
		local Ent60 = ents.FindByClass("gmod_wire_hydraulic")
				for _,Ent60 in pairs(Ent60) do
						if Ent60:IsValid() then
							local phys60 = Ent60:GetPhysicsObject()
							phys60:EnableMotion(False)
						end
				end
				
		local Ent61 = ents.FindByClass("gmod_wire_igniter")
				for _,Ent61 in pairs(Ent61) do
						if Ent61:IsValid() then
							local phys61 = Ent61:GetPhysicsObject()
							phys61:EnableMotion(False)
						end
				end
		
		local Ent62 = ents.FindByClass("gmod_wire_indicator")
				for _,Ent62 in pairs(Ent62) do
						if Ent62:IsValid() then
							local phys62 = Ent62:GetPhysicsObject()
							phys62:EnableMotion(False)
						end
				end
				
		local Ent63 = ents.FindByClass("gmod_wire_input")
				for _,Ent63 in pairs(Ent63) do
						if Ent63:IsValid() then
							local phys63 = Ent63:GetPhysicsObject()
							phys63:EnableMotion(False)
						end
				end
		
		local Ent64 = ents.FindByClass("gmod_wire_keyboard")
				for _,Ent64 in pairs(Ent64) do
						if Ent64:IsValid() then
							local phys64 = Ent64:GetPhysicsObject()
							phys64:EnableMotion(False)
						end
				end
				
		local Ent65 = ents.FindByClass("gmod_wire_keypad")
				for _,Ent65 in pairs(Ent65) do
						if Ent65:IsValid() then
							local phys65 = Ent65:GetPhysicsObject()
							phys65:EnableMotion(False)
						end
				end
				
		local Ent66 = ents.FindByClass("gmod_wire_las_receiver")
				for _,Ent66 in pairs(Ent66) do
						if Ent66:IsValid() then
							local phys66 = Ent66:GetPhysicsObject()
							phys66:EnableMotion(False)
						end
				end
				
		local Ent67 = ents.FindByClass("gmod_wire_latch")
				for _,Ent67 in pairs(Ent67) do
						if Ent67:IsValid() then
							local phys67 = Ent67:GetPhysicsObject()
							phys67:EnableMotion(False)
						end
				end
				
		local Ent68 = ents.FindByClass("gmod_wire_lever")
				for _,Ent68 in pairs(Ent68) do
						if Ent68:IsValid() then
							local phys68 = Ent68:GetPhysicsObject()
							phys68:EnableMotion(False)
						end
				end
				
		local Ent69 = ents.FindByClass("gmod_wire_locator")
				for _,Ent69 in pairs(Ent69) do
						if Ent69:IsValid() then
							local phys69 = Ent69:GetPhysicsObject()
							phys69:EnableMotion(False)
						end
				end
				
		local Ent70 = ents.FindByClass("gmod_wire_motor")
				for _,Ent70 in pairs(Ent70) do
						if Ent70:IsValid() then
							local phys70 = Ent70:GetPhysicsObject()
							phys70:EnableMotion(False)
						end
				end
				
		local Ent71 = ents.FindByClass("gmod_wire_nailer")
				for _,Ent71 in pairs(Ent71) do
						if Ent71:IsValid() then
							local phys71 = Ent71:GetPhysicsObject()
							phys71:EnableMotion(False)
						end
				end
				
		local Ent72 = ents.FindByClass("gmod_wire_numpad")
				for _,Ent72 in pairs(Ent72) do
						if Ent72:IsValid() then
							local phys72 = Ent72:GetPhysicsObject()
							phys72:EnableMotion(False)
						end
				end
				
		local Ent73 = ents.FindByClass("gmod_wire_oscilloscope")
				for _,Ent73 in pairs(Ent73) do
						if Ent73:IsValid() then
							local phys73 = Ent73:GetPhysicsObject()
							phys73:EnableMotion(False)
						end
				end
				
		local Ent74 = ents.FindByClass("gmod_wire_output")
				for _,Ent74 in pairs(Ent74) do
						if Ent74:IsValid() then
							local phys74 = Ent74:GetPhysicsObject()
							phys74:EnableMotion(False)
						end
				end
				
		local Ent75 = ents.FindByClass("gmod_wire_pixel")
				for _,Ent75 in pairs(Ent75) do
						if Ent75:IsValid() then
							local phys75 = Ent75:GetPhysicsObject()
							phys75:EnableMotion(False)
						end
				end
				
		local Ent76 = ents.FindByClass("gmod_wire_socket")
				for _,Ent76 in pairs(Ent76) do
						if Ent76:IsValid() then
							local phys76 = Ent76:GetPhysicsObject()
							phys76:EnableMotion(False)
						end
				end
				
		local Ent77 = ents.FindByClass("gmod_wire_pod")
				for _,Ent77 in pairs(Ent77) do
						if Ent77:IsValid() then
							local phys77 = Ent77:GetPhysicsObject()
							phys77:EnableMotion(False)
						end
				end
				
		local Ent78 = ents.FindByClass("gmod_wire_radio")
				for _,Ent78 in pairs(Ent78) do
						if Ent78:IsValid() then
							local phys78 = Ent78:GetPhysicsObject()
							phys78:EnableMotion(False)
						end
				end
				
		local Ent79 = ents.FindByClass("gmod_wire_ranger")
				for _,Ent79 in pairs(Ent79) do
						if Ent79:IsValid() then
							local phys79 = Ent79:GetPhysicsObject()
							phys79:EnableMotion(False)
						end
				end
				
		local Ent80 = ents.FindByClass("gmod_wire_relay")
				for _,Ent80 in pairs(Ent80) do
						if Ent80:IsValid() then
							local phys80 = Ent80:GetPhysicsObject()
							phys80:EnableMotion(False)
						end
				end
				
		local Ent81 = ents.FindByClass("gmod_wire_dhdd")
				for _,Ent81 in pairs(Ent81) do
						if Ent81:IsValid() then
							local phys81 = Ent81:GetPhysicsObject()
							phys81:EnableMotion(False)
						end
				end
				
		local Ent82 = ents.FindByClass("gmod_wire_screen")
				for _,Ent82 in pairs(Ent82) do
						if Ent82:IsValid() then
							local phys82 = Ent82:GetPhysicsObject()
							phys82:EnableMotion(False)
						end
				end
				
		local Ent83 = ents.FindByClass("gmod_wire_sensor")
				for _,Ent83 in pairs(Ent83) do
						if Ent83:IsValid() then
							local phys83 = Ent83:GetPhysicsObject()
							phys83:EnableMotion(False)
						end
				end
				
		local Ent84 = ents.FindByClass("gmod_wire_simple_explosive")
				for _,Ent84 in pairs(Ent84) do
						if Ent84:IsValid() then
							local phys84 = Ent84:GetPhysicsObject()
							phys84:EnableMotion(False)
						end
				end
				
		local Ent85 = ents.FindByClass("gmod_wire_soundemitter")
				for _,Ent85 in pairs(Ent85) do
						if Ent85:IsValid() then
							local phys85 = Ent85:GetPhysicsObject()
							phys85:EnableMotion(False)
						end
				end
				
		local Ent86 = ents.FindByClass("gmod_wire_spawner")
				for _,Ent86 in pairs(Ent86) do
						if Ent86:IsValid() then
							local phys86 = Ent86:GetPhysicsObject()
							phys86:EnableMotion(False)
						end
				end
				
		local Ent87 = ents.FindByClass("gmod_wire_speedometer")
				for _,Ent87 in pairs(Ent87) do
						if Ent87:IsValid() then
							local phys87 = Ent87:GetPhysicsObject()
							phys87:EnableMotion(False)
						end
				end
				
		local Ent88 = ents.FindByClass("gmod_wire_spu")
				for _,Ent88 in pairs(Ent88) do
						if Ent88:IsValid() then
							local phys88 = Ent88:GetPhysicsObject()
							phys88:EnableMotion(False)
						end
				end
				
		local Ent89 = ents.FindByClass("gmod_wire_target_finder")
				for _,Ent89 in pairs(Ent89) do
						if Ent89:IsValid() then
							local phys89 = Ent89:GetPhysicsObject()
							phys89:EnableMotion(False)
						end
				end
				
		local Ent90 = ents.FindByClass("gmod_wire_teleporter")
				for _,Ent90 in pairs(Ent90) do
						if Ent90:IsValid() then
							local phys90 = Ent90:GetPhysicsObject()
							phys90:EnableMotion(False)
						end
				end
				
		local Ent91 = ents.FindByClass("gmod_wire_textentry")
				for _,Ent91 in pairs(Ent91) do
						if Ent91:IsValid() then
							local phys91 = Ent91:GetPhysicsObject()
							phys91:EnableMotion(False)
						end
				end
				
		local Ent92 = ents.FindByClass("gmod_wire_textreceiver")
				for _,Ent92 in pairs(Ent92) do
						if Ent92:IsValid() then
							local phys92 = Ent92:GetPhysicsObject()
							phys92:EnableMotion(False)
						end
				end
				
		local Ent93 = ents.FindByClass("gmod_wire_textscreen")
				for _,Ent93 in pairs(Ent93) do
						if Ent93:IsValid() then
							local phys93 = Ent93:GetPhysicsObject()
							phys93:EnableMotion(False)
						end
				end
				
		local Ent94 = ents.FindByClass("gmod_wire_trail")
				for _,Ent94 in pairs(Ent94) do
						if Ent94:IsValid() then
							local phys94 = Ent94:GetPhysicsObject()
							phys94:EnableMotion(False)
						end
				end
				
		local Ent95 = ents.FindByClass("gmod_wire_turret")
				for _,Ent95 in pairs(Ent95) do
						if Ent95:IsValid() then
							local phys95 = Ent95:GetPhysicsObject()
							phys95:EnableMotion(False)
						end
				end
				
		local Ent96 = ents.FindByClass("gmod_wire_twoway_radio")
				for _,Ent96 in pairs(Ent96) do
						if Ent96:IsValid() then
							local phys96 = Ent96:GetPhysicsObject()
							phys96:EnableMotion(False)
						end
				end
				
		local Ent96 = ents.FindByClass("gmod_wire_user")
				for _,Ent96 in pairs(Ent96) do
						if Ent96:IsValid() then
							local phys96 = Ent96:GetPhysicsObject()
							phys96:EnableMotion(False)
						end
				end
				
		local Ent97 = ents.FindByClass("gmod_wire_value")
				for _,Ent97 in pairs(Ent97) do
						if Ent97:IsValid() then
							local phys97 = Ent97:GetPhysicsObject()
							phys97:EnableMotion(False)
						end
				end
				
		local Ent98 = ents.FindByClass("gmod_wire_vehicle")
				for _,Ent98 in pairs(Ent98) do
						if Ent98:IsValid() then
							local phys98 = Ent98:GetPhysicsObject()
							phys98:EnableMotion(False)
						end
				end
				
		local Ent99 = ents.FindByClass("gmod_wire_watersensor")
				for _,Ent99 in pairs(Ent99) do
						if Ent99:IsValid() then
							local phys99 = Ent99:GetPhysicsObject()
							phys99:EnableMotion(False)
						end
				end
				
		local Ent100 = ents.FindByClass("gmod_wire_waypoint")
				for _,Ent100 in pairs(Ent100) do
						if Ent100:IsValid() then
							local phys100 = Ent100:GetPhysicsObject()
							phys100:EnableMotion(False)
						end
				end
				
		local Ent101 = ents.FindByClass("gmod_wire_weight")
				for _,Ent101 in pairs(Ent101) do
						if Ent101:IsValid() then
							local phys101 = Ent101:GetPhysicsObject()
							phys101:EnableMotion(False)
						end
				end
				
		local Ent102 = ents.FindByClass("gmod_wire_weight")
				for _,Ent102 in pairs(Ent102) do
						if Ent102:IsValid() then
							local phys102 = Ent102:GetPhysicsObject()
							phys102:EnableMotion(False)
						end
				end
				
		local Ent103 = ents.FindByClass("gmod_wire_wheel")
				for _,Ent103 in pairs(Ent103) do
						if Ent103:IsValid() then
							local phys103 = Ent103:GetPhysicsObject()
							phys103:EnableMotion(False)
						end
				end
				
		local Ent104 = ents.FindByClass("gmod_laser")
				for _,Ent104 in pairs(Ent104) do
						if Ent104:IsValid() then
							local phys104 = Ent104:GetPhysicsObject()
							phys104:EnableMotion(False)
						end
				end
        ulx.fancyLogAdmin( calling_ply, "#A has Stopped the Lag!" )
end
local nolag = ulx.command( "Utility", "ulx nolag", ulx.nolag, "!nolag" )
nolag:defaultAccess( ULib.ACCESS_ADMIN )
nolag:help( "Freeze All Prop and Light Entities on the server in hope of reducing lag." )
