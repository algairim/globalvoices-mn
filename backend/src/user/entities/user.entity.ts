import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, OneToMany } from 'typeorm';
import { Note } from '../../notes/entities/note.entity'; // For relation

@Entity()
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  // CRITICAL FIX: Add keycloakId to link local user to Keycloak token (sub claim)
  @Column({ unique: true, nullable: false })
  keycloakId: string;

  // We rely on Keycloak to manage the username/email
  @Column({ unique: true })
  username: string;

  @Column({ unique: true })
  email: string;

  @CreateDateColumn()
  createdAt: Date;

  // --- Relations ---

  @OneToMany(() => Note, (note) => note.user)
  notes: Note[];
}
