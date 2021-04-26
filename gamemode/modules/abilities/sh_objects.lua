ss.abilities.Create('flyattack')
    :SetName('Fly Attack')
    :SetDescription('')
    :SetResourceCost(2)
    :SetCooldown(5)
    :SetIcon(Material('materials/galactic/ui/ree.png', 'smooth'))
    :OnSelected(function(self, pl)
		print 'Selected'
    end)
    :OnDeselected(function(self, pl)
		print 'Deselected'
    end)
    :OnRequested(function(self, pl, data)
		print 'OnRequested'
    end)
    :OnExit(function(self, pl, data)
		print 'On Exit'
    end)
    :OnThink(function(self, pl, data)

    end)