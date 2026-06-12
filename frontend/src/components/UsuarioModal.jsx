import { useState, useEffect } from 'react';
import { createUsuario, updateUsuario } from '../api/usuariosService';
import styles from '../styles/usuarios.module.css';

function UsuarioModal({ usuario, onClose, onSave }) {
  const isEdit = usuario !== null;
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [nombre, setNombre] = useState('');
  const [email, setEmail] = useState('');
  const [rol, setRol] = useState('USER');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (isEdit) {
      setUsername(usuario.username || '');
      setPassword('');
      setNombre(usuario.nombre || '');
      setEmail(usuario.email || '');
      setRol(usuario.rol || 'USER');
    }
  }, [usuario, isEdit]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const data = { username, nombre, email, rol };

      if (!isEdit) {
        data.password = password;
      } else if (password.trim() !== '') {
        data.password = password;
      }

      if (isEdit) {
        await updateUsuario(usuario.id, data);
      } else {
        await createUsuario(data);
      }

      setUsername('');
      setPassword('');
      setNombre('');
      setEmail('');
      setRol('USER');
      onSave();
    } catch (err) {
      setError('Error al guardar usuario');
    } finally {
      setLoading(false);
    }
  };

  const handleOverlayClick = (e) => {
    if (e.target === e.currentTarget) {
      onClose();
    }
  };

  return (
    <div className={styles.overlay} onClick={handleOverlayClick}>
      <div className={styles.modal}>
        <div className={styles.modalHeader}>
          <h2>{isEdit ? 'Editar Usuario' : 'Nuevo Usuario'}</h2>
          <button onClick={onClose} className={styles.closeBtn}>&times;</button>
        </div>
        <form onSubmit={handleSubmit} className={styles.modalForm}>
          {error && <p className={styles.error}>{error}</p>}
          <div className={styles.field}>
            <label htmlFor="modal-username">Username</label>
            <input
              id="modal-username"
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
            />
          </div>
          <div className={styles.field}>
            <label htmlFor="modal-password">
              {isEdit ? 'Contraseña (dejar vacío para no cambiar)' : 'Contraseña'}
            </label>
            <input
              id="modal-password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder={isEdit ? 'Dejar vacío para no cambiar' : ''}
              required={!isEdit}
            />
          </div>
          <div className={styles.field}>
            <label htmlFor="modal-nombre">Nombre</label>
            <input
              id="modal-nombre"
              type="text"
              value={nombre}
              onChange={(e) => setNombre(e.target.value)}
              required
            />
          </div>
          <div className={styles.field}>
            <label htmlFor="modal-email">Email</label>
            <input
              id="modal-email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div className={styles.field}>
            <label htmlFor="modal-rol">Rol</label>
            <select
              id="modal-rol"
              value={rol}
              onChange={(e) => setRol(e.target.value)}
            >
              <option value="USER">USER</option>
              <option value="ADMIN">ADMIN</option>
            </select>
          </div>
          <div className={styles.modalActions}>
            <button type="button" onClick={onClose} className={styles.cancelBtn}>Cancelar</button>
            <button type="submit" className={styles.saveBtn} disabled={loading}>
              {loading ? 'Guardando...' : 'Guardar'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default UsuarioModal;
