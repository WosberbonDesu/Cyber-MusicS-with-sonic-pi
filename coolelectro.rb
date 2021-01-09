use_bpm 110
define :fat_beat do | drum, snare, volBd, volSn |
  sample drum, amp: volBd, lpf: 120, cutoff: 100, pan: -0.3
  sleep 1.5
  sample drum, amp: volBd, lpf: 120, cutoff: 100, pan: -0.3
  sleep 0.5
  sample snare, amp: volSn, pan: 0.3
  sleep 1.5
  2.times do
    sample drum, amp: volBd, lpf: 120, cutoff: 100, pan: -0.3
    sleep 1
  end
  sample drum, amp: volBd, lpf: 120, cutoff: 100, pan: -0.3
  sleep 0.5
  sample snare, amp: volSn, pan: 0.3
  sleep 2
end


live_loop :tick do
  4.times do |bar|
    puts 'bar no. ' + (bar + 1).to_s
    4.times do |beat|
      puts 'beat no. ' + (beat + 1).to_s
      cue :tick
      sleep 1
    end
  end
end

live_loop :drums, sync: :tick do
  bd = :bd_tek
  sn = :elec_lo_snare
  with_fx :reverb do
    in_thread do
      2.times do
        fat_beat bd, sn, 2, 0.7
      end
    end
    64.times do
      sample :drum_cymbal_pedal, amp: 1.3, rate: 1.5, release: 0.05 if (spread 3,8).tick
      sample :drum_cymbal_closed, amp: 1.2, rate: 2, release: 0.05 if (spread 6,8).look
      sleep 0.25
    end
  end
end

live_loop :bassLine, sync: :drums do
  use_synth :dsaw
  with_fx :slicer do
    play_pattern_timed [:e2, :g2, :a2, :b2, :d2], [4,4,4,2,2], amp: 0.8, sustain: 1, decay: 1, release: 0.5, cutoff: 80
  end
end
live_loop :computerImpro, sync: :tick do
  use_synth :prophet
  notes1 = (scale :e3, :minor_pentatonic, num_octaves: 2)
  notes2 = (scale :g6, :major_pentatonic, num_octaves: 2)
  64.times do
    play notes1.take(3).tick, amp: rrand(0.2, 0.4), release: 0.05, decay: 0.1
    play notes2.choose, amp: rrand(0.3, 0.6), release: 0.05, decay: 0.1
    sleep 0.25
  end
end
live_loop :pianoComp, sync: :bassLine do
  use_synth :piano
  2.times do
    play (chord :g3, :major, num_octaves: 2), amp: 2
    sleep 0.5
    play (chord :g3, :major, num_octaves: 2), amp: 1.5
    sleep 3.5
  end
  sleep 1
  play (chord :a3, :minor, num_octaves: 2), amp: 2
  sleep 4
  play (chord :b3, :minor, num_octaves: 2), amp: 2
  sleep 3
end