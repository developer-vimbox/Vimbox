package com.vimbox.sales;

public class Item {
    private String name;
    private String remark;
    private double charges;
    private double units;
    private double qty;

    public Item(String name, String remark, double charges, double units, double qty) {
        this.name = name;
        this.remark = remark;
        this.charges = charges;
        this.units = units;
        this.qty = qty;
    }

    public String getName() {
        return name;
    }

    public String getRemark() {
        return remark;
    }

    public double getCharges() {
        return charges;
    }

    public double getUnits() {
        return units;
    }

    public double getQty() {
        return qty;
    }     
}
