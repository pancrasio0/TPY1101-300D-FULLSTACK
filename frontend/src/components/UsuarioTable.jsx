import styles from '../styles/usuarios.module.css';

function UsuarioTable({ usuarios, onEdit, onDelete }) {
  return (
    <div className={styles.tableWrapper}>
      <table className={styles.table}>
        <thead>
          <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Nombre</th>
            <th>Email</th>
            <th>Rol</th>
            <th>Activo</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          {usuarios.length === 0 ? (
            <tr>
              <td colSpan="7" className={styles.empty}>No hay usuarios registrados</td>
            </tr>
          ) : (
            usuarios.map((usuario) => (
              <tr key={usuario.id}>
                <td>{usuario.id}</td>
                <td>{usuario.username}</td>
                <td>{usuario.nombre}</td>
                <td>{usuario.email}</td>
                <td>{usuario.rol}</td>
                <td>{usuario.activo ? 'Sí' : 'No'}</td>
                <td>
                  <button
                    onClick={() => onEdit(usuario)}
                    className={styles.editBtn}
                  >
                    Editar
                  </button>
                  <button
                    onClick={() => onDelete(usuario.id)}
                    className={styles.deleteBtn}
                  >
                    Eliminar
                  </button>
                </td>
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
}

export default UsuarioTable;
