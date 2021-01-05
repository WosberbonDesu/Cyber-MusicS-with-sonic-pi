# Welcome to Sonic Pi
use_bpm 123



master = (ramp *range(0, 1, 0.01))
kick_volume = 1
bass_volume = 1
revbass_volume = 1
snare_volume = 0.5
hats_volume = 0.5
open_hats_volume = 1
synth_volume = 1
pad_volume = 1
beep_volume = 0.5

live_loop :bass do
  play :c1
  sleep 0.50
  play :c1
  sleep 2
  play :e1
  sleep 0.50
  play :f1
  sleep 1
  
end


#fadein = (ramp *range(0, 1, 0.01))
fadein = (ring 0.1)

kick_cutoffs = range(50, 80, 0.5).mirror
live_loop :kick do
  if (spread 1, 4).tick then
    sample :bd_tek, amp: fadein.look * 1, cutoff: kick_cutoffs.look
  end
  sleep 0.25
end
define :snare do |amp|
  sample :sn_dolf, amp: amp, start: 0.15, finish: 0.35, rate: 0.7
end
live_loop :snares do
  sleep 1
  snare 1 * fadein.tick
  sleep 1
end
live_loop :snare_break do
  sync :snares
  sleep 15.75
  with_fx :reverb, mix: 0.3, room: 0.8 do
    with_fx :echo, mix: 0.4, decay: 12, phase: 0.75 do
      snare 0.5
    end
  end
  sleep 0.25
end
live_loop :hats do
  sync :kick
  if(spread 3, 8).tick then
    with_fx :rhpf, cutoff: 125, res: 0.8 do
      
      with_synth :pnoise do
        play :d1, attack: 0.05, decay: 0.08, release: 0.1
      end
    end
  end
  sleep 0.25
end
live_loop :noise_hats do
  sync :kick
  with_fx :slicer, mix: 1, phase: 0.25, pulse_width: 0.1 do
    with_fx :hpf, cutoff: 130 do
      with_synth :noise do
        play :d1, decay: 0.5
        sleep 1
      end
    end
  end
  sleep 1
end
bassline_rhythm = (ring 1, 0, 0, 0, 1, 0, 0, 0,
                   1, 0, 0.5, 0, 1, 0, 0.5, 0)
bassline_notes = (stretch [:d1] * 6 + [:f1, :f1, :a1, :f1], 4)
live_loop :bassline do
  sync :kick
  with_synth :fm do
    play bassline_notes.look, amp: fadein.look * bassline_rhythm.tick,
      attack: 0.03, divisor: 1, depth: 2.5
  end
  sleep 0.25
end

live_loop :revbassline do
  sync :snares
  sleep 7.5
  with_fx :pan, pan: -0.5 do
    
    with_synth :fm do
      play :d1, attack: 0.5, divisor: 0.5, depth: 6
      sleep 0.5
    end
  end
end

dchord = chord(:d2, :minor, num_octaves: 3)
synth_rhythm = (ring 1.5, 1.5, 1)
synth_cutoffs = range(60, 100, 0.5).mirror
live_loop :synth do
  sync :kick
  with_synth_defaults release: 0.05 do
    with_synth :sine do
      play_chord dchord
    end
    cutoff = synth_cutoffs.look
    with_fx :ixi_techno, cutoff_min: cutoff,
    cutoff_max: cutoff - 30, phase: 1, res: 0.3 do
      
      with_synth :dsaw do
        play_chord dchord
      end
    end
  end
  
  sleep synth_rhythm.tick
end