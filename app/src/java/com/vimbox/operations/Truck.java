package com.vimbox.operations;

public class Truck {
    private String carplateNo;
    private String name;

    public Truck(String carplateNo, String name) {
        this.carplateNo = carplateNo;
        this.name = name;
    }

    public String getCarplateNo() {
        return carplateNo;
    }

    public String getName() {
        return name;
    }
    
    public String toString(){
        return name + " (" + carplateNo + ")";
    }
}
