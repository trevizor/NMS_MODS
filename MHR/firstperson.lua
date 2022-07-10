local function get_localplayer()
    local player_manager = sdk.get_managed_singleton("snow.player.PlayerManager")
    if not player_manager then 
        return nil
    end

    local player = player_manager:call("findMasterPlayer")
    if not player then 
        return nil
    end

    return player
end

local function get_player_head_joint()
    local player = get_localplayer()
    if not player then return nil end

    local player_gameobject = player:call("get_GameObject")
    if not player_gameobject then return nil end

    local player_transform = player_gameobject:call("get_Transform")
    if not player_transform then return nil end
    return player_transform:call("getJointByName", "Head_00")
end

local function get_camera_joint()
    local camera = sdk.get_primary_camera()
    if not camera then return nil end

    local camera_gameobject = camera:call("get_GameObject")
    if not camera_gameobject then return nil end

    local camera_transform = camera_gameobject:call("get_Transform")
    if not camera_transform then return nil end

    return camera_transform:call("get_Joints"):get_elements()[1]
end

re.on_pre_application_entry("PrepareRendering", function()
    local player_head = get_player_head_joint()

    if player_head then
        player_head:call("set_LocalScale", Vector3f.new(0, 0, 0))
    end
end)

re.on_pre_application_entry("BeginRendering", function()
    local player_head = get_player_head_joint()
    local camera_joint = get_camera_joint()

    if not player_head or not camera_joint then return end
    local headpos = player_head:call("get_Position")
    headpos = Vector3f.new(headpos.x-0.05, headpos.y+0.08, headpos.z-0.05)
    camera_joint:call("set_Position", headpos)
end)