import { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { getUsuarios, deleteUsuario } from '../api/usuariosService';
import UsuarioTable from '../components/UsuarioTable';
import UsuarioModal from '../components/UsuarioModal';
import styles from '../styles/usuarios.module.css';

function UsuariosPage() {
  const [usuarios, setUsuarios] = useState([]);
  const [error, setError] = useState('');
  const [modalOpen, setModalOpen] = useState(false);
  const [selectedUsuario, setSelectedUsuario] = useState(null);
  const { logout } = useAuth();
  const navigate = useNavigate();

  const cargarUsuarios = useCallback(async () => {
    try {
      const response = await getUsuarios();
      setUsuarios(response.data);
      setError('');
    } catch (err) {
      setError('Error al cargar usuarios');
    }
  }, []);

  useEffect(() => {
    cargarUsuarios();
  }, [cargarUsuarios]);

  const handleLogout = () => {
    logout();
    navigate('/login', { replace: true });
  };

  const handleNuevo = () => {
    setSelectedUsuario(null);
    setModalOpen(true);
  };

  const handleEdit = (usuario) => {
    setSelectedUsuario(usuario);
    setModalOpen(true);
  };

  const handleDelete = async (id) => {
    if (!window.confirm('¿Estás seguro de eliminar este usuario?')) return;

    try {
      await deleteUsuario(id);
      cargarUsuarios();
    } catch (err) {
      setError('Error al eliminar usuario');
    }
  };

  const handleCloseModal = () => {
    setModalOpen(false);
    setSelectedUsuario(null);
  };

  const handleSave = () => {
    handleCloseModal();
    cargarUsuarios();
  };

  return (
    <div className={styles.container}>
      <header className={styles.header}>
        <h1>Mantenedor de Usuarios</h1>
        <button onClick={handleLogout} className={styles.logoutBtn}>Cerrar Sesión</button>
      </header>

      {error && <p className={styles.error}>{error}</p>}

      <div className={styles.toolbar}>
        <button onClick={handleNuevo} className={styles.nuevoBtn}>Nuevo Usuario</button>
      </div>

      <UsuarioTable
        usuarios={usuarios}
        onEdit={handleEdit}
        onDelete={handleDelete}
      />

      {modalOpen && (
        <UsuarioModal
          usuario={selectedUsuario}
          onClose={handleCloseModal}
          onSave={handleSave}
        />
      )}
    </div>
  );
}

export default UsuariosPage;
