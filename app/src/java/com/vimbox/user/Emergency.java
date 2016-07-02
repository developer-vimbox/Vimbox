package com.vimbox.user;

public class Emergency {
    private String name;
    private String relationship;
    private int contact;
    private int office;

    public Emergency(String name, String relationship, int contact, int office) {
        this.name = name;
        this.relationship = relationship;
        this.contact = contact;
        this.office = office;
    }

    public String getName() {
        return name;
    }

    public String getRelationship() {
        return relationship;
    }

    public int getContact() {
        return contact;
    }

    public int getOffice() {
        return office;
    }
}
