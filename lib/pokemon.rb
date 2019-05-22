class Pokemon
  attr_accessor :id, :name, :type, :db, :hp

  def initialize(id:, name:, type:, db:)
    @id = id
    @name = name
    @type = type
    @db = db
  end

  def self.save(name, type, db)
    sql = <<-SQL
      INSERT INTO pokemon (name, type)
      VALUES (?, ?)
    SQL
    db.prepare(sql).execute(name, type)
    #PREPARE-prepares a statement for execution. Goes in template of prepared statements.
  end

  def self.find(id, db)
    sql = <<-SQL
      SELECT *
      FROM pokemon
      WHERE id = ?
      LIMIT 1
    SQL
    rows_array = db.prepare(sql).execute(id)
    pokemon_array = rows_array.collect do |row|
      new_pokemon = Pokemon.new(id: id, name: row[1], type: row[2], db: db)
      new_pokemon.hp = row[3]
      new_pokemon
    end
    pokemon_array[0]
  end

  def alter_hp(hp, db)
    sql = <<-SQL
      UPDATE pokemon
      SET hp = ?
      WHERE id = ?
    SQL
    db.prepare(sql).execute(hp, self.id)
  end
end
