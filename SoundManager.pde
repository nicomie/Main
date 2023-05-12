import java.util.ArrayList;

class SoundManager {
    ArrayList<Sound> units;

    public SoundManager() {
        units = new ArrayList<>();

    }

    void add_sound(Sound s){
        units.add(s);
    }

    void make_sound(PVector pos) {
        for (Sound s : units) {
            s.perceive_sound(pos);
        }
    }
}
