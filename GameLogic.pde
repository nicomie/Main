class GameLogic {
    Grid map;
    ArrayList<GameObject> entities = new ArrayList<>();;

    GameLogic(Grid _map) {
        map = _map;
    }

    public void registerEntity(GameObject o){
        entities.add(o);
    }


  
} 