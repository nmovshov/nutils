function y=solsys()
%SOLSYS Bodies in the solar system.
% SOLSYS() returns a structure with data on bodies in the solar system. It
% is arranged in a primary/satellite order but the easiest way to navigate
% the structure is probably by auto-completion steps (TAB presses). The
% data is taken mostly from www.nineplanets.org. This is a work in
% progress. Data will be added over time but there is no attempt of
% completeness.
%
% Called m-functions: setUnits (physunits toolbox)
%
% Naor, March 2006, September 2011.

si=setUnits;

%% The Sun
y.Sun.radius     = 6.955e08*si.m;
y.Sun.mass       = 1.989e30*si.kg;
y.Sun.luminosity = 3.85e26*si.joule/si.second;

%% Jupiter
y.Jupiter.diameter  = 142984*si.km;
y.Jupiter.orbit     = 778330000*si.km;
y.Jupiter.mass      = 1.89819e27*si.kg;
y.Jupiter.mythology = '(aka Zeus) King of the Gods, ruler of Olympus, patron of the Roman state.';
% --- Jupiter's satellites ---
    % -- Adrastea --
    y.Jupiter.satellites.Adrastea.diameter  = 2.0e4*si.m;
    y.Jupiter.satellites.Adrastea.orbit     = 1.29e8*si.m;
    y.Jupiter.satellites.Adrastea.mass      = 1.91e16*si.kg;
    y.Jupiter.satellites.Adrastea.mythology = 'Distributer of rewards and punishments, daughter of Zeus';
    % -- Amalthea --
    y.Jupiter.satellites.Amalthea.diameter  = 1.89e5*si.m;
    y.Jupiter.satellites.Amalthea.orbit     = 1.813e8*si.m;
    y.Jupiter.satellites.Amalthea.mass      = 3.5e18*si.kg;
    y.Jupiter.satellites.Amalthea.mythology = 'Nymph, nursed infant Zeus with goat''s milk';
    % -- Ananke --
    y.Jupiter.satellites.Ananke.diameter    = 3.0e4*si.m;
    y.Jupiter.satellites.Ananke.orbit       = 2.12e10*si.m;
    y.Jupiter.satellites.Ananke.mass        = 3.82e16*si.kg;
    y.Jupiter.satellites.Ananke.mythology   = 'Mother of Adrastea, by Zeus';
    % -- Callisto --
    y.Jupiter.satellites.Callisto.diameter  = 4.8e6*si.m;
    y.Jupiter.satellites.Callisto.orbit     = 1.833e9*si.m;
    y.Jupiter.satellites.Callisto.mass      = 1.08e23*si.kg;
    y.Jupiter.satellites.Callisto.mythology = 'Nymph, also - Ursa Major';
    % -- Carme --
    y.Jupiter.satellites.Carme.diameter     = 4.0e4*si.m;
    y.Jupiter.satellites.Carme.orbit        = 2.26e10*si.m;
    y.Jupiter.satellites.Carme.mass         = 9.56e16*si.kg;
    y.Jupiter.satellites.Carme.mythology    = 'Mother, by Zeus, of Britomartis';
    % -- Elara --
    y.Jupiter.satellites.Elara.diameter     = 7.6e4*si.m;
    y.Jupiter.satellites.Elara.orbit        = 1.174e10*si.m;
    y.Jupiter.satellites.Elara.mass         = 7.77e17*si.kg;
    y.Jupiter.satellites.Elara.mythology    = 'Mother, by Zeus, of Tityus';
    % -- Europa --
    y.Jupiter.satellites.Europa.diameter     = 3.138e6*si.m;
    y.Jupiter.satellites.Europa.orbit       = 6.709e8*si.m;
    y.Jupiter.satellites.Europa.mass        = 4.8e22*si.kg;
    y.Jupiter.satellites.Europa.mythology   = 'Phoencian princess, abducted by Zeus, mother of Minos';
    % -- Ganymede --
    y.Jupiter.satellites.Ganymede.diameter  = 5.262e6*si.m;
    y.Jupiter.satellites.Ganymede.orbit     = 1.07e9*si.m;
    y.Jupiter.satellites.Ganymede.mass      = 1.48e23*si.kg;
    y.Jupiter.satellites.Ganymede.mythology = 'Trojan boy, cup bearer to the gods';
    % -- Himalia --
    y.Jupiter.satellites.Himalia.diameter   = 1.86e5*si.m;
    y.Jupiter.satellites.Himalia.orbit      = 1.148e10*si.m;
    y.Jupiter.satellites.Himalia.mass       = 9.56e18*si.kg;
    y.Jupiter.satellites.Himalia.mythology  = 'Nymph, bore three sons of Zeus';
    % -- Io --
    y.Jupiter.satellites.Io.diameter        = 3.63e6*si.m;
    y.Jupiter.satellites.Io.orbit           = 4.22e8*si.m;
    y.Jupiter.satellites.Io.mass            = 8.93e22*si.kg;
    y.Jupiter.satellites.Io.mythology       = 'Maiden, loved by Zeus, transformed into heifer';
    % -- Leda --
    y.Jupiter.satellites.Leda.diameter      = 1.6e4*si.m;
    y.Jupiter.satellites.Leda.orbit         = 1.109e10*si.m;
    y.Jupiter.satellites.Leda.mass          = 5.68e15*si.kg;
    y.Jupiter.satellites.Leda.mythology     = 'Queen of Sparta, mother of Pollux and Helen';
    % -- Lysithea --
    y.Jupiter.satellites.Lysithea.diameter  = 3.6e4*si.m;
    y.Jupiter.satellites.Lysithea.orbit     = 1.172e10*si.m;
    y.Jupiter.satellites.Lysithea.mass      = 7.77e16*si.kg;
    y.Jupiter.satellites.Lysithea.mythology = 'Daughter of Oceanus, lover of Zeus';
    % -- Metis --
    y.Jupiter.satellites.Metis.diameter     = 4.0e4*si.m;
    y.Jupiter.satellites.Metis.orbit        = 1.28e8*si.m;
    y.Jupiter.satellites.Metis.mass         = 9.56e16*si.kg;
    y.Jupiter.satellites.Metis.mythology    = 'Titaness, first wife of Zeus (Jupiter)';
    % -- Pasiphea --
    y.Jupiter.satellites.Pasiphea.diameter  = 5.0e4*si.m;
    y.Jupiter.satellites.Pasiphea.orbit     = 2.35e10*si.m;
    y.Jupiter.satellites.Pasiphea.mass      = 1.91e17*si.kg;
    y.Jupiter.satellites.Pasiphea.mythology = 'Wife of Minos, mother of the Minotaur';
    % -- Thebe --
    y.Jupiter.satellites.Thebe.diameter     = 1.0e5*si.m;
    y.Jupiter.satellites.Thebe.orbit        = 2.22e8*si.m;
    y.Jupiter.satellites.Thebe.mass         = 7.77e17*si.kg;
    y.Jupiter.satellites.Thebe.mythology    = 'Nymph, daughter of the river god Asopus';
    
%% Saturn
y.Saturn.diameter  = 120536*si.km;
y.Saturn.orbit     = 1429400000*si.km;
y.Saturn.mass      = 5.68e26*si.kg;
y.Saturn.mythology = 'God of agriculture. Aka Cronus, son of Uranus and Gaia, father of Zeus (Jupiter).';
% --- Saturn's satellites ---
    % -- Atlas --
    y.Saturn.satellites.Atlas.diameter       = 3.0e4*si.m;
    y.Saturn.satellites.Atlas.orbit          = 1.377e8*si.m;
    y.Saturn.satellites.Atlas.mass           = NaN;
    y.Saturn.satellites.Atlas.mythology      = 'Titan, condemned to support the heavens upon his shoulders';
    % -- Calypso --
    y.Saturn.satellites.Calypso.diameter     = 2.6e4*si.m;
    y.Saturn.satellites.Calypso.orbit        = 2.947e8*si.m;
    y.Saturn.satellites.Calypso.mass         = NaN;
    y.Saturn.satellites.Calypso.mythology    = 'Sea nymph, delayed Odysseus on her island for seven years';
    % -- Dione --
    y.Saturn.satellites.Dione.diameter       = 1.12e6*si.m;
    y.Saturn.satellites.Dione.orbit          = 3.774e8*si.m;
    y.Saturn.satellites.Dione.mass           = 1.05e21*si.kg;
    y.Saturn.satellites.Dione.mythology      = 'Mother of Aphrodite by Zeus';
    % -- Enceladus --
    y.Saturn.satellites.Enceladus.diameter   = 4.98e5*si.m;
    y.Saturn.satellites.Enceladus.orbit      = 2.38e8*si.m;
    y.Saturn.satellites.Enceladus.mass       = 7.3e19*si.kg;
    y.Saturn.satellites.Enceladus.mythology  = 'Titan, defeated by Athena';
    % -- Epimetheus --
    y.Saturn.satellites.Epimetheus.diameter  = 1.15e5*si.m;
    y.Saturn.satellites.Epimetheus.orbit     = 1.514e8*si.m;
    y.Saturn.satellites.Epimetheus.mass      = 5.6e17*si.kg;
    y.Saturn.satellites.Epimetheus.mythology = 'Brother of Prometheus and Atlas, husband of Pandora';
    % -- Helene --
    y.Saturn.satellites.Helene.diameter      = 3.3e4*si.m;
    y.Saturn.satellites.Helene.orbit         = 3.774e8*si.m;
    y.Saturn.satellites.Helene.mass          = NaN;
    y.Saturn.satellites.Helene.mythology     = 'Amazon, battled with Achilles';
    % -- Hyperion --
    y.Saturn.satellites.Hyperion.diameter    = 2.86e5*si.m;
    y.Saturn.satellites.Hyperion.orbit       = 1.481e9*si.m;
    y.Saturn.satellites.Hyperion.mass        = 1.77e19*si.kg;
    y.Saturn.satellites.Hyperion.mythology   = 'A Titan, father of Helios';
    % -- Iapetus --
    y.Saturn.satellites.Iapetus.diameter     = 1.46e6*si.m;
    y.Saturn.satellites.Iapetus.orbit        = 3.561e9*si.m;
    y.Saturn.satellites.Iapetus.mass         = 1.88e21*si.kg;
    y.Saturn.satellites.Iapetus.mythology    = 'Titan, ancestor of the human race';
    % -- Janus --
    y.Saturn.satellites.Janus.diameter       = 1.78e5*si.m;
    y.Saturn.satellites.Janus.orbit          = 1.515e8*si.m;
    y.Saturn.satellites.Janus.mass           = 2.01e18*si.kg;
    y.Saturn.satellites.Janus.mythology      = 'God of gates and doorways';
    % -- Mimas --
    y.Saturn.satellites.Mimas.diameter       = 3.92e5*si.m;
    y.Saturn.satellites.Mimas.orbit          = 1.855e8*si.m;
    y.Saturn.satellites.Mimas.mass           = 3.8e19*si.kg;
    y.Saturn.satellites.Mimas.mythology      = 'Titan, slain by Hercules';
    % -- Pan --
    y.Saturn.satellites.Pan.diameter         = 2.0e4*si.m;
    y.Saturn.satellites.Pan.orbit            = 1.336e8*si.m;
    y.Saturn.satellites.Pan.mass             = NaN;
    y.Saturn.satellites.Pan.mythology        = 'God of woods, fields, and flocks';
    % -- Pandora --
    y.Saturn.satellites.Pandora.diameter     = 8.4e4*si.m;
    y.Saturn.satellites.Pandora.orbit        = 1.417e8*si.m;
    y.Saturn.satellites.Pandora.mass         = 2.2e17*si.kg;
    y.Saturn.satellites.Pandora.mythology    = 'first woman, a punishment on humankind';
    % -- Phoebe --
    y.Saturn.satellites.Phoebe.diameter      = 2.2e5*si.m;
    y.Saturn.satellites.Phoebe.orbit         = 1.295e10*si.m;
    y.Saturn.satellites.Phoebe.mass          = 4.0e18*si.kg;
    y.Saturn.satellites.Phoebe.mythology     = 'Grandmother of Apollo';
    % -- Prometheus --
    y.Saturn.satellites.Prometheus.diameter  = 9.1e4*si.m;
    y.Saturn.satellites.Prometheus.orbit     = 1.394e8*si.m;
    y.Saturn.satellites.Prometheus.mass      = 2.7e17*si.kg;
    y.Saturn.satellites.Prometheus.mythology = 'Titan, stole fire from Olympus to give to humankind';
    % -- Rhea --
    y.Saturn.satellites.Rhea.diameter        = 1.53e6*si.m;
    y.Saturn.satellites.Rhea.orbit           = 5.27e8*si.m;
    y.Saturn.satellites.Rhea.mass            = 2.49e21*si.kg;
    y.Saturn.satellites.Rhea.mythology       = 'Mother of Hades, Hera, Poseidon, and Zeus';
    % -- Telesto --
    y.Saturn.satellites.Telesto.diameter     = 2.9e4*si.m;
    y.Saturn.satellites.Telesto.orbit        = 2.947e8*si.m;
    y.Saturn.satellites.Telesto.mass         = NaN;
    y.Saturn.satellites.Telesto.mythology    = 'Daughter of Oceanus and Tethys';
    % -- Tethys --
    y.Saturn.satellites.Tethys.diameter      = 1.06e6*si.m;
    y.Saturn.satellites.Tethys.orbit         = 2.947e8*si.m;
    y.Saturn.satellites.Tethys.mass          = 6.22e20*si.kg;
    y.Saturn.satellites.Tethys.mythology     = 'Titaness and sea goddess, sister and wife of Oceanus';
    % -- Titan --
    y.Saturn.satellites.Titan.diameter       = 5.15e6*si.m;
    y.Saturn.satellites.Titan.orbit          = 1.222e9*si.m;
    y.Saturn.satellites.Titan.mass           = 1.35e23*si.kg;
    y.Saturn.satellites.Titan.mythology      = 'A family of giants, children of Uranus and Gaia';
    
%% Earth
y.Earth.diameter = 12756.3*si.km;
y.Earth.orbit    = 149600000*si.km;
y.Earth.mass     = 5.972e24*si.kg;

%% The Moon
y.Moon.diameter = 3476*si.km;
y.Moon.orbit    = 384400*si.km;
y.Moon.mass     = 7.35e22*si.kg;

%% Mars
y.Mars.diameter  = 6794*si.km;
y.Mars.orbit     = 227940000*si.km;
y.Mars.mass      = 6.4219e23*si.kg;
y.Mars.mythology = 'Roman god of war, (greek Ares)';
% --- Mars' satellites ---
    % -- Phobos --
    y.Mars.satellites.Phobos.diameter  = 22.2*si.km; % mean
    y.Mars.satellites.Phobos.orbit     = 9378*si.km;
    y.Mars.satellites.Phobos.mass      = 1.0668e16*si.kg; % Andert et al. 2010
    y.Mars.satellites.Phobos.mythology = 'one of the sons of Ares (Mars)';
    % -- Deimos --
    y.Mars.satellites.Deimos.diameter  = 12.6*si.km; % mean
    y.Mars.satellites.Deimos.orbit     = 23459*si.km;
    y.Mars.satellites.Deimos.mass      = 1.8e15*si.kg;
    y.Mars.satellites.Deimos.mythology = 'one of the sons of Ares (Mars)';

%% Uranus
y.Uranus.diameter  = 51118*si.km;
y.Uranus.orbit     = 2870990000*si.km;
y.Uranus.mass      = 8.683e25*si.kg;
y.Uranus.mythology = 'Ancient Greek deity of the Heavens, earliest supreme god.';
% --- Uranus' satellites ---
    % -- Miranda --
    y.Uranus.satellites.Miranda.diameter  = 472*si.km; 
    y.Uranus.satellites.Miranda.orbit     = 129850*si.km;
    y.Uranus.satellites.Miranda.mass      = 6.3e19*si.kg;
    y.Uranus.satellites.Miranda.mythology = 'Daughter of Prospero in The Tempest';
    % -- Ariel --
    y.Uranus.satellites.Ariel.diameter  = 1158*si.km; 
    y.Uranus.satellites.Ariel.orbit     = 190930*si.km;
    y.Uranus.satellites.Ariel.mass      = 1.27e21*si.kg;
    y.Uranus.satellites.Ariel.mythology = 'A mischievous airy spirit in The Tempest';
    % -- Umbriel --
    y.Uranus.satellites.Umbriel.diameter  = 1170*si.km;
    y.Uranus.satellites.Umbriel.orbit     = 265980*si.km;
    y.Uranus.satellites.Umbriel.mass      = 1.27e21*si.kg;
    y.Uranus.satellites.Umbriel.mythology = 'Character in The Rape of the Lock'; 
    % -- Titania -- 
    y.Uranus.satellites.Titania.diameter  = 1578*si.km;
    y.Uranus.satellites.Titania.orbit     = 436270*si.km;
    y.Uranus.satellites.Titania.mass      = 3.49e21*si.kg;
    y.Uranus.satellites.Titania.mythology = ['Queen of the Fairies in Midsummer-Night' char(39) 's Dream'];
    % -- Oberon --
    y.Uranus.satellites.Oberon.diameter  = 1523*si.km;
    y.Uranus.satellites.Oberon.orbit     = 583420*si.km;
    y.Uranus.satellites.Oberon.mass      = 3.03e21*si.kg;
    y.Uranus.satellites.Oberon.mythology = ['King of the Fairies in Midsummer-Night' char(39) 's Dream'];
end % of function solsys
