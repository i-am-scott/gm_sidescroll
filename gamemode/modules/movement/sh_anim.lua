anim = anim or {}
CUSTOM_ANIMATION = 123412451

function anim.PlaySequence(pl, seq, loop)
	if not IsValid(pl) then
		return
	end

	local seqid = pl:LookupSequence(seq)
	if not seqid or seqid == -1 then
		return
	end

    pl.customanimloop = loop
	pl.customanim = true
	pl:DoCustomAnimEvent(CUSTOM_ANIMATION, seqid)
	pl.customanim = false

	if SERVER then
		net.Start 'ss.anim.PlaySequence'
			net.WritePlayer(pl)
			net.WriteString(seq)
            net.WriteBool(loop)
		net.Broadcast()
	end
end

function PLAYER:PlayAnimation(seq, loop)
    anim.PlaySequence(self, seq, loop)
end

hook('DoAnimationEvent', function(pl, event, seqid)
	if not pl.customanim or event ~= CUSTOM_ANIMATION then
		return
	end

	pl:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, seqid, 0, not pl.customanimloop)
	pl:AnimSetGestureWeight(GESTURE_SLOT_ATTACK_AND_RELOAD, 1)
	return ACT_INVALID
end)

concommand.Add('fanim', function(pl, _, _, str, _)
    pl:PlayAnimation(str, false)
end)

if SERVER then
    util.AddNetworkString 'anim.PlaySequence'
else
	net('anim.PlaySequence', function()
		local pl = net.ReadPlayer()
		local seq_id = net.ReadString()
		anim.PlaySequence(pl, seq_id, net.ReadBool())
	end)
end