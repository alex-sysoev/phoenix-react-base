import React, { Component, PropTypes }  from 'react';
import { connect }                      from 'react-redux';
import { Link }                         from 'react-router';
import { logout }                       from '../store/auth/actions';

class Header extends Component {

  static contextTypes = {
    router: PropTypes.object
  }

  onLogoutClick() {
    this.props.logout(this.context.router);
  }

  renderSignButtons() {
    const { currentUser } = this.props.auth;

    if (!this.props.auth.authenticated) {
      return(
        <ul className="nav nav-pills pull-right">
          <li><Link to="/login" className="btn btn-success">Sign in</Link></li>
          <li><Link to="/signup" className="btn btn-primary">Sign up</Link></li>
        </ul>
      );
    } else {
      const admin = <li><Link to="/admin" className="btn btn-primary">Admin</Link></li>;
      const isAdmin = currentUser.roles.map(r => r.name).includes("admin");
      
      return(
        <ul className="nav nav-pills pull-right">
          { isAdmin && admin }
          <li>
            <Link to="/profile" className="btn btn-success">
              {`Hi, ${currentUser.first_name}`}
            </Link>
          </li>
          <li>
            <button className="btn btn-danger" onClick={this.onLogoutClick.bind(this)}>
              Logout
            </button>
          </li>
        </ul>
      );
    }
  }

	render() {
		return(
      <header className="col-md-12 header">
        <div className="pull-left">
          <Link to="/"><h1>PHOENIX CHAT</h1></Link>
        </div>
        <nav role="navigation">
          { this.renderSignButtons() }
        </nav>
      </header>
		);
	}
}

function mapStateToProps(state) {
  return { auth: state.auth };
}

export default connect(mapStateToProps, {logout})(Header);